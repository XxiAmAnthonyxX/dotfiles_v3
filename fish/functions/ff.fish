function ff --description "Fuzzy find file and open in nvim"
    set -l file (fd --type f --hidden --exclude .git | fzf --preview 'bat --color=always --style=numbers --line-range=:300 {}')
    test -n "$file"; and nvim "$file"
end
