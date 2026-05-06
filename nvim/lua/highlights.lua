local function apply_highlights()
  vim.api.nvim_set_hl(0, "LineNr", { fg = "#5c6370" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e5c07b", bold = true })
end

apply_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = apply_highlights,
})
