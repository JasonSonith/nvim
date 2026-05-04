return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    })

    vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
    vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })
    vim.keymap.set("n", "<leader>bp", ":BufferLinePick<CR>", { silent = true })
    vim.keymap.set("n", "<leader>bc", ":bdelete<CR>", { silent = true })
    vim.keymap.set("n", "<leader>1", ":BufferLineGoToBuffer 1<CR>", { silent = true })
    vim.keymap.set("n", "<leader>2", ":BufferLineGoToBuffer 2<CR>", { silent = true })
    vim.keymap.set("n", "<leader>3", ":BufferLineGoToBuffer 3<CR>", { silent = true })
    vim.keymap.set("n", "<leader>4", ":BufferLineGoToBuffer 4<CR>", { silent = true })
    vim.keymap.set("n", "<leader>5", ":BufferLineGoToBuffer 5<CR>", { silent = true })
  end,
}
