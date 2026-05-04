return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("treesitter-context").setup({
      enable = true,
      max_lines = 3,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 1,
      trim_scope = "outer",
      mode = "cursor",
      separator = nil,
      zindex = 20,
    })

    vim.keymap.set("n", "<leader>ct", ":TSContextToggle<CR>", { silent = true, desc = "Toggle context" })
    vim.keymap.set("n", "[c", function()
      require("treesitter-context").go_to_context(vim.v.count1)
    end, { silent = true, desc = "Jump to context" })

    vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#181825" })
    vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "#181825", fg = "#7f849c" })
    vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "#45475a" })
  end,
}
