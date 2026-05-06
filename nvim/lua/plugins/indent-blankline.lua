return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    enabled = false,
    scope = { enabled = true, show_start = true, show_end = false },
  },
  keys = {
    { "<leader>i", "<cmd>IBLToggle<cr>", desc = "Toggle indent guides" },
  },
}
