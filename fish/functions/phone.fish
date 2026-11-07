function phone
    # Mount any MTP devices gio knows about
    gio mount -li 2>/dev/null | awk -F= '
        /activation_root=mtp:/ {
            uri=$2
            gsub(/^[ \t]+|[ \t]+$/, "", uri)
            if (uri != "") system("gio mount \"" uri "\" 2>/dev/null")
        }'

    set -l gvfs /run/user/(id -u)/gvfs
    set -l mounts $gvfs/mtp:host=*

    if test (count $mounts) -eq 0
        echo "No phone mounted. Unlock it, set USB to File transfer, and allow access."
        return 1
    end

    # One device → open it; several → open the gvfs parent
    if test (count $mounts) -eq 1
        yazi $mounts[1]
    else
        yazi $gvfs
    end
end
