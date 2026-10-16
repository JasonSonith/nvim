return {
  "folke/flash.nvim",
  vscode = true,
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },
  opts = {
    modes = {
      char = { enabled = false },
    },
  },
}
