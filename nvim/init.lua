-- Ultimate Neovim config
-- Leader must be set before lazy
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim and load the rest
require("config.lazy")
