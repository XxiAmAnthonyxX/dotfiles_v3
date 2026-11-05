return {
  {
    "RedsXDD/neopywal.nvim",
    name = "neopywal",
    lazy = false,
    priority = 1000,
    opts = {
      -- Supports both pywal and wallust
      -- use_palette = "wallust", -- uncomment if you use wallust instead of pywal
    },
    config = function(_, opts)
      require("neopywal").setup(opts)
      vim.cmd.colorscheme("neopywal")
    end,
  },
}
