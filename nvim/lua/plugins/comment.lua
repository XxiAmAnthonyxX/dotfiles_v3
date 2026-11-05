return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- Add a space between comment and the line
    padding = true,
    -- Whether the cursor should stay at its position
    sticky = true,
    -- Lines to be ignored while (un)comment
    ignore = nil,
    -- LHS of toggle mappings in NORMAL mode
    toggler = {
      line = "gcc",
      block = "gbc",
    },
    -- LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
      line = "gc",
      block = "gb",
    },
  },
}
