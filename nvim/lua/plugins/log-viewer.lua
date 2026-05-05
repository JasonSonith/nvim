vim.filetype.add({
  extension = { log = "log" },
  pattern = {
    [".*%.log%.%d+"] = "log",
    [".*%.log%.%d+%.gz"] = "log",
  },
})

return {
  "MTDL9/vim-log-highlighting",
  ft = "log",
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "log",
      callback = function()
        vim.opt_local.wrap = false
        vim.opt_local.number = false
        vim.opt_local.cursorline = true
      end,
    })
  end,
}
