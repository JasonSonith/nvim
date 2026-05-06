local function apply_highlights()
  vim.api.nvim_set_hl(0, "LineNr", { fg = "#a6adc8" })
  vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#a6adc8" })
  vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#a6adc8" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#f9e2af", bold = true })
end

apply_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = apply_highlights,
})
