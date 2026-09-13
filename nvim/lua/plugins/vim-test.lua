return {
  "vim-test/vim-test",
  dependencies = {
    "preservim/vimux"
  },
  config = function()
    vim.keymap.set("n", "<leader>tt", ":TestNearest<CR>", { desc = "Run nearest test" })
    vim.keymap.set("n", "<leader>tf", ":TestFile<CR>", { desc = "Run file tests" })
    vim.keymap.set("n", "<leader>ta", ":TestSuite<CR>", { desc = "Run all tests" })
    vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", { desc = "Run last test" })
    vim.keymap.set("n", "<leader>tv", ":TestVisit<CR>", { desc = "Visit last test file" })
    vim.cmd("let test#strategy = 'vimux'")
  end,
}
