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
      on_attach = function(buf)
        return vim.bo[buf].filetype ~= "markdown"
      end,
    })

    vim.keymap.set("n", "<leader>ct", ":TSContextToggle<CR>", { silent = true, desc = "Toggle context" })
    vim.keymap.set("n", "[c", function()
      require("treesitter-context").go_to_context(vim.v.count1)
    end, { silent = true, desc = "Jump to context" })

    -- Pull from catppuccin's palette so colors stay in sync if we ever swap flavors,
    -- and reapply on ColorScheme so highlights survive plugin-triggered reloads.
    -- Gated by catppuccin* pattern so it doesn't bleed into other active themes.
    local function apply_hl()
      local C = require("catppuccin.palettes").get_palette("mocha")
      vim.api.nvim_set_hl(0, "TreesitterContext", { bg = C.mantle })
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = C.mantle, fg = C.overlay1 })
      vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = C.surface1 })
    end
    if vim.g.colors_name and vim.g.colors_name:match("^catppuccin") then
      apply_hl()
    end
    local group = vim.api.nvim_create_augroup("TreesitterContextCatppuccin", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = group,
      pattern = "catppuccin*",
      callback = apply_hl,
    })
  end,
}
