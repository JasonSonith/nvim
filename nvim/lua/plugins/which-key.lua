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
      { "<leader>cv", desc = "Toggle code suggestions" },
      { "<leader>r", group = "rename" },
      { "<leader>m", group = "markdown" },
      { "<leader>t", desc = "Run nearest test" },
      { "<leader>1", desc = "Tab 1" },
      { "<leader>2", desc = "Tab 2" },
      { "<leader>3", desc = "Tab 3" },
      { "<leader>4", desc = "Tab 4" },
      { "<leader>5", desc = "Tab 5" },
      { "<leader>e", desc = "Toggle file tree" },
      { "<leader>h", desc = "Clear search highlight" },
      { "<leader>i", desc = "Toggle indent guides" },
      { "<leader>w", desc = "Save file" },
      { "<leader>q", desc = "Quit" },
      { "<leader>l", desc = "Run last test" },
      { "<leader>a", desc = "Run all tests" },
      { "<leader>T", desc = "Run file tests" },
      { "<leader>u",  group = "ui / theme" },
      { "<leader>uc", desc = "Catppuccin" },
      { "<leader>uk", desc = "Kanagawa" },
      { "<leader>uv", desc = "VSCode" },
      { "<leader>ur", desc = "Rose Pine" },
      { "<leader>ub", desc = "Toggle transparency" },
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
