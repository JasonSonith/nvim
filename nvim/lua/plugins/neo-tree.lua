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
          return
        end

        -- File arg: pick a tree root that actually contains the file so
        -- follow_current_file doesn't trigger neo-tree's "File not in cwd" prompt.
        local file_path = vim.fn.fnamemodify(arg, ":p")
        local cwd = vim.fn.getcwd():gsub("/$", "") .. "/"
        local root
        if vim.startswith(file_path, cwd) then
          root = vim.fn.getcwd()
        else
          root = vim.fn.fnamemodify(file_path, ":h")
        end
        vim.cmd("Neotree filesystem show left dir=" .. vim.fn.fnameescape(root))
      end,
    })
  end,
}
