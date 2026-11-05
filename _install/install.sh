#!/bin/bash
set -euo pipefail

DISK="/dev/nvme0n1"
HOSTNAME="Arch"
USERNAME="x"
ROOT_PASSWORD="321"
USER_PASSWORD="123"
TIMEZONE="America/Chicago"

echo "=============================================="
echo "  Arch install about to start"
echo "  Disk:       $DISK"
echo "  Hostname:   $HOSTNAME"
echo "  Username:   $USERNAME"
echo "  Timezone:   $TIMEZONE"
echo "=============================================="
read -rp "Type 'yes' to continue: " confirm
[[ "$confirm" == "yes" ]] || {
  echo "Aborted."
  exit 1
}

echo "=== Partitioning ==="
sgdisk --zap-all "$DISK"
sgdisk -n1:0:+1G -t1:EF00 -c1:EFI "$DISK"
sgdisk -n2:0:0 -t2:8300 -c2:ROOT "$DISK"

echo "=== Formatting ==="
mkfs.fat -F32 "${DISK}p1"
mkfs.btrfs -L arch -f "${DISK}p2"

echo "=== Creating subvolumes ==="
mount "${DISK}p2" /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@pkg
umount /mnt

echo "=== Mounting ==="
mount -o compress=zstd,noatime,ssd,space_cache=v2,subvol=@ "${DISK}p2" /mnt
mkdir -p /mnt/{boot,home,.snapshots,var/log,var/cache/pacman/pkg}

mount -o compress=zstd,noatime,ssd,space_cache=v2,subvol=@home "${DISK}p2" /mnt/home
mount -o compress=zstd,noatime,ssd,space_cache=v2,subvol=@snapshots "${DISK}p2" /mnt/.snapshots
mount -o compress=zstd,noatime,ssd,space_cache=v2,subvol=@log "${DISK}p2" /mnt/var/log
mount -o compress=zstd,noatime,ssd,space_cache=v2,subvol=@pkg "${DISK}p2" /mnt/var/cache/pacman/pkg
mount "${DISK}p1" /mnt/boot

echo "=== Installing base system ==="
pacstrap -K /mnt \
  base base-devel \
  linux-zen linux-zen-headers linux-firmware \
  btrfs-progs \
  amd-ucode \
  sudo \
  grub efibootmgr

echo "=== Generating fstab ==="
genfstab -U /mnt >>/mnt/etc/fstab

echo "=== Configuring system ==="
arch-chroot /mnt /bin/bash <<EOF
set -euo pipefail

# Timezone
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

# Locale
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hostname
echo "$HOSTNAME" > /etc/hostname
cat > /etc/hosts <<HOSTS
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain $HOSTNAME
HOSTS

# Root password
echo "root:$ROOT_PASSWORD" | chpasswd

# User
useradd -m -G wheel -s /bin/bash "$USERNAME"
echo "$USERNAME:$USER_PASSWORD" | chpasswd

# Sudo
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Bootloader
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Networking
systemctl enable systemd-networkd
systemctl enable systemd-resolved
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# Create basic network config for DHCP on ethernet
cat > /etc/systemd/network/20-wired.network <<NET
[Match]
Name=en*

[Network]
DHCP=yes
NET
EOF

echo
echo "=== Installation complete ==="
echo "You can now reboot:"
echo "  umount -R /mnt"
echo "  reboot"
echo
echo "After first boot, run your setup.sh"
