return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      window = {
        width = 32,
      },
      filesystem = {
        hijack_netrw_behavior = "open_current",
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    })

    vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left toggle<CR>", { silent = true })
    vim.keymap.set("n", "<leader>e", ":Neotree filesystem reveal left toggle<CR>", { silent = true })
    vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", { silent = true })

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if vim.fn.argc() == 0 then
          return
        end
        local arg = vim.fn.argv(0)
        if vim.fn.isdirectory(arg) == 1 then
          vim.cmd("Neotree filesystem position=current dir=" .. vim.fn.fnameescape(arg))
        else
          vim.cmd("Neotree filesystem show left")
        end
      end,
    })
  end,
}
