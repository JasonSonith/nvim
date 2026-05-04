return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 300,
    win = {
      border = "rounded",
    },
    spec = {
      { "<leader>b", group = "buffer" },
      { "<leader>g", group = "git / lsp goto" },
      { "<leader>f", group = "find" },
      { "<leader>c", group = "code" },
      { "<leader>r", group = "rename" },
      { "<leader>t", group = "test" },
      { "<leader>1", desc = "Tab 1" },
      { "<leader>2", desc = "Tab 2" },
      { "<leader>3", desc = "Tab 3" },
      { "<leader>4", desc = "Tab 4" },
      { "<leader>5", desc = "Tab 5" },
      { "<leader>e", desc = "Toggle file tree" },
      { "<leader>h", desc = "Clear search highlight" },
      { "<leader>w", desc = "Save file" },
      { "<leader>q", desc = "Quit" },
      { "<leader>l", desc = "Run last test" },
      { "<leader>a", desc = "Run all tests" },
      { "<leader>T", desc = "Run file tests" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
