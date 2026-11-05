function fcd --description "Fuzzy find directory and cd"
    set -l dir (fd --type d --hidden --exclude .git | fzf --preview 'eza -la --icons --group-directories-first --git --color=always {}')
    test -n "$dir"; and cd "$dir"
end
