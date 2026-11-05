return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false, -- required: does not support lazy-loading
  build = ":TSUpdate",
  config = function()
    -- New nvim-treesitter API (main branch rewrite)
    require("nvim-treesitter").setup({})

    -- Common parsers (prebuilt / don't need tree-sitter CLI in most cases)
    -- Add "hyprlang" / "qmljs" later after installing tree-sitter-cli
    require("nvim-treesitter").install({
      "lua",
      "vim",
      "vimdoc",
      "bash",
      "markdown",
      "markdown_inline",
      "json",
      "yaml",
      "toml",
      "regex",
      "query",
    })

    -- Enable treesitter highlighting for installed languages
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
      callback = function(args)
        local ok = pcall(vim.treesitter.start, args.buf)
        if ok then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
      end,
    })
  end,
}
