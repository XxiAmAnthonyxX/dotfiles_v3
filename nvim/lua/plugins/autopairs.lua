return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true, -- use treesitter
    ts_config = {
      lua = { "string" },
      javascript = { "template_string" },
    },
  },
}
