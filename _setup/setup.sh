#!/usr/bin/env bash
set -euo pipefail

# Install packages
sudo pacman -S --needed --noconfirm \
  git base-devel \
  ufw \
  zram-generator \
  snapper snap-pac grub-btrfs inotify-tools \
  pacman-contrib \
  reflector

# Update mirrorlist
sudo reflector --verbose --country 'United States' --age 12 --protocol https --sort rate --fastest 10 --save /etc/pacman.d/mirrorlist
sudo pacman -Syu --noconfirm

# Install yay
if ! command -v yay &>/dev/null; then
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
  rm -rf /tmp/yay
fi

# Configure zram
sudo tee /etc/systemd/zram-generator.conf >/dev/null <<EOF
[zram0]
zram-size = min(ram / 2, 16384)
compression-algorithm = zstd
swap-priority = 100
EOF

sudo systemctl daemon-reload

# Configure snapshots
sudo umount /.snapshots 2>/dev/null || true
sudo rmdir /.snapshots 2>/dev/null || true

sudo snapper -c root create-config /
sudo btrfs subvolume delete /.snapshots
sudo mkdir /.snapshots
sudo mount -a
sudo chmod 750 /.snapshots
sudo chown :wheel /.snapshots

sudo sed -i 's/TIMELINE_LIMIT_HOURLY="10"/TIMELINE_LIMIT_HOURLY="5"/' /etc/snapper/configs/root
sudo sed -i 's/TIMELINE_LIMIT_DAILY="10"/TIMELINE_LIMIT_DAILY="7"/' /etc/snapper/configs/root
sudo sed -i 's/TIMELINE_LIMIT_MONTHLY="10"/TIMELINE_LIMIT_MONTHLY="0"/' /etc/snapper/configs/root
sudo sed -i 's/TIMELINE_LIMIT_YEARLY="10"/TIMELINE_LIMIT_YEARLY="0"/' /etc/snapper/configs/root

sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
sudo systemctl enable --now grub-btrfsd.service

# Configure firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo systemctl enable ufw

# Official packages
sudo pacman -S --needed --noconfirm \
  hyprland xdg-desktop-portal-hyprland hyprpolkitagent grim slurp xdg-utils qt6-wayland qt6-declarative \
  pipewire wireplumber pipewire-pulse pipewire-alsa lib32-pipewire lib32-libpulse wiremix cava playerctl alsa-utils \
  capitaine-cursors ttf-jetbrains-mono-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji awww \
  kitty fish starship fastfetch \
  eza bat fd sd ripgrep fzf zoxide atuin ouch less jq glow hexyl mediainfo perl-image-exiftool \
  yazi imv mpv ffmpeg ffmpegthumbnailer imagemagick poppler resvg \
  udiskie udisks2 gvfs gvfs-mtp libmtp android-udev android-tools \
  btop rocm-smi-lib \
  cliphist wl-clipboard wl-clip-persist \
  steam mesa vulkan-radeon lib32-mesa lib32-vulkan-radeon \
  librewolf quickshell neovim

# AUR packages
yay -S --needed --noconfirm \
  python-pywal16 python-pywalfox mpvpaper \
  xdg-desktop-portal-termfilechooser-hunkyburrito-git

# Configs
cp -r /mnt/backup/DOTS/{btop,cava,fastfetch,fish,hypr,kitty,nvim,quickshell,starship,wal,xdg-desktop-portal,xdg-desktop-portal-termfilechooser,yazi,mimeapps.list} ~/.config/
cp -r /mnt/backup/DOTS/{yazi.desktop} ~/.local/share/applications/

# Shell
chsh -s /usr/bin/fish

# Yazi
ya pkg install
update-desktop-database ~/.local/share/applications

# Useful timers
sudo systemctl enable --now fstrim.timer
sudo systemctl enable --now paccache.timer

sudo reboot
