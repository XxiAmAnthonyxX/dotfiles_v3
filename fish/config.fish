if status is-interactive
    set -g fish_greeting
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml
    set -gx BAT_THEME ansi
    set -gx FZF_DEFAULT_OPTS "--color=16 --height=45% --layout=reverse --border --info=inline --preview-window=right:60%:wrap"

    alias ls "eza -a --icons --group-directories-first --header"
    alias la "eza -la --icons --group-directories-first --header"
    alias cat bat
    alias grep rg
    alias find fd
    alias sed sd
    alias extract "ouch decompress"
    alias compress "ouch compress"
    alias .. "cd .."
    alias ... "cd ../.."
    alias .... "cd ../../.."

    zoxide init fish | source
    atuin init fish | source
    fzf --fish | source
    starship init fish | source

    fastfetch -c ~/.config/fastfetch/fastfetch.jsonc
end
