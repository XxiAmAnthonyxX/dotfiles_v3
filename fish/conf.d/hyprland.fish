if status is-login
    and test -z "$WAYLAND_DISPLAY"
    and test -z "$DISPLAY"
    and test "$XDG_VTNR" -eq 1
    exec start-hyprland
end
