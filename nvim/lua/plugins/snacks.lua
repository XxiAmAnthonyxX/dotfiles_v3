return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- Core QoL
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    input = { enabled = true },
    rename = { enabled = true },
    bufdelete = { enabled = true },

    -- Indent guides (replaces indent-blankline if desired)
    indent = {
      enabled = true,
      char = "│",
    },

    -- Notifications
    notifier = {
      enabled = true,
      timeout = 3000,
    },

    -- Dashboard
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "e", desc = "Explorer", action = ":lua Snacks.explorer()" },
          { icon = " ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },

    -- File explorer (picker-based)
    explorer = {
      enabled = true,
      replace_netrw = true,
    },

    -- Fuzzy picker (replaces fzf-lua / telescope)
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            ["<C-c>"] = { "close", mode = { "i", "n" } },
          },
        },
      },
    },

    -- Terminal (replaces toggleterm)
    terminal = {
      enabled = true,
      win = {
        style = "float",
      },
    },

    -- Zen mode
    zen = { enabled = true },

    -- Explicitly disable git-related snacks (user requested no git plugins)
    git = { enabled = false },
    gitbrowse = { enabled = false },
    gh = { enabled = false },
    lazygit = { enabled = false },
  },
  keys = {
    -- Picker
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>fc", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace Symbols" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>fD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>/", function() Snacks.picker.search_history() end, desc = "Search History" },

    -- Explorer
    { "<leader>e", function() Snacks.explorer() end, desc = "Explorer" },

    -- Terminal
    { "<C-\\>", function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<leader>tt", function() Snacks.terminal() end, desc = "Toggle Terminal" },

    -- Notifier
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss Notifications" },
    { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Notification History" },

    -- Buffer
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },

    -- Zen
    { "<leader>z", function() Snacks.zen() end, desc = "Zen Mode" },
    { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Zoom" },

    -- Scratch
    { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
  },
}
