return {
  "stevearc/oil.nvim",
  config = function()
    local oil = require("oil")
    oil.setup({
      default_file_explorer = false,
    })
    vim.keymap.set("n", "-", oil.toggle_float, {})
  end,
}
