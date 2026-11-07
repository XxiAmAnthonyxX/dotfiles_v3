function bak --description "Create a timestamped backup of a file"
    set -l file $argv[1]
    test -n "$file"; or begin
        echo "Usage: bak <file>"
        return 1
    end
    test -e "$file"; or begin
        echo "File not found: $file"
        return 1
    end
    set -l dest "$file.bak."(date +%Y-%m-%d_%H-%M-%S)
    cp -a "$file" "$dest"; and echo "Backed up → $dest"
end
