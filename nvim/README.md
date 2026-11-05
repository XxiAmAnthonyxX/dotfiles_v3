# Ultimate Neovim Config

A clean, modular Neovim configuration built from scratch (2026).

## Structure

```
nvim/
├── init.lua
├── README.md
└── lua/
    ├── config/
    │   ├── options.lua
    │   ├── keymaps.lua
    │   ├── autocmds.lua
    │   └── lazy.lua
    └── plugins/                 # one file per plugin
        ├── colorscheme.lua      # neopywal (pywal/wallust)
        ├── snacks.lua           # terminal, picker, explorer, dashboard, …
        ├── treesitter.lua
        ├── mason.lua
        ├── mason-lspconfig.lua
        ├── lsp.lua
        ├── blink.lua
        ├── conform.lua
        ├── lualine.lua
        ├── which-key.lua
        ├── flash.lua
        ├── surround.lua
        ├── comment.lua
        ├── autopairs.lua
        ├── bufferline.lua
        ├── devicons.lua
        └── plenary.lua
```

## Installation

```bash
# Backup existing config if needed
mv ~/.config/nvim ~/.config/nvim.bak

# Copy this folder
cp -r nvim ~/.config/nvim

# Launch Neovim – lazy.nvim installs everything on first start
nvim
```

Then run `:Mason` and install any missing language servers / formatters / linters.

## Colorscheme

**[neopywal.nvim](https://github.com/RedsXDD/neopywal.nvim)** – applies your pywal / wallust palette automatically.

Generate colors first:

```bash
wal -i /path/to/your/wallpaper
# or with wallust:
# wallust run /path/to/your/wallpaper
```

If you use **wallust** instead of pywal, set `use_palette = "wallust"` in `lua/plugins/colorscheme.lua`.

## Languages configured

| Language   | LSP        | Formatter   |
|------------|------------|-------------|
| Lua        | lua_ls     | stylua      |
| Bash / sh  | bashls     | shfmt       |
| Markdown   | marksman   | prettier    |

Diagnostics come from LSP. Nix / QML / Hyprland tooling can be added later when needed.

## Key leader

`<Space>` is the leader key.

## Most useful keymaps

| Key            | Action                          |
|----------------|----------------------------------|
| `<leader>e`    | Snacks Explorer                  |
| `<leader>ff`   | Find files (Snacks picker)       |
| `<leader>fg`   | Live grep                        |
| `<leader>fb`   | Buffers                          |
| `<leader>fr`   | Recent files                     |
| `<C-\>`        | Toggle terminal (Snacks)         |
| `<leader>tt`   | Toggle terminal                  |
| `s` / `S`      | Flash jump / Treesitter          |
| `gcc`          | Toggle comment                   |
| `<leader>cf`   | Format buffer                    |
| `<leader>bd`   | Delete buffer (Snacks)           |
| `<leader>z`    | Zen mode                         |
| `gd` / `gr` / `K` | LSP definition / refs / hover |

## What was intentionally removed

- All Git plugins (gitsigns, Neogit, diffview, snacks git modules)
- Terminal plugin (toggleterm → replaced by Snacks.terminal)
- fzf-lua (replaced by Snacks.picker)
- Catppuccin / pywal16.nvim (switched to neopywal.nvim)
- indent-blankline (replaced by Snacks.indent)
- nvim-lint (diagnostics via LSP only)
- oil.nvim (use Snacks explorer instead)

## Notes

- Each plugin lives in its own file under `lua/plugins/`.
- Disable any plugin by deleting or commenting out its file.
- After changing specs run `:Lazy sync`.
