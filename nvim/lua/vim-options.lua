vim.g.mapleader = " "

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.background = "dark"

vim.opt.swapfile = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.showtabline = 2
vim.opt.cursorline = false
vim.opt.scrolloff = 8
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- Over SSH, route +/* registers through OSC52 so yanks land in the local
-- terminal's clipboard (Windows Terminal / WezTerm / etc). No-op locally.
if os.getenv("SSH_TTY") then
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
  }
end

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.undofile = true

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<leader>w", ":w<CR>", { silent = true })
vim.keymap.set("n", "<leader>q", ":q<CR>", { silent = true })

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

local function smart_insert(default_key)
  return function()
    if vim.v.count > 0 then
      vim.api.nvim_feedkeys(vim.v.count .. default_key, "n", false)
      return
    end
    local line = vim.api.nvim_get_current_line()
    if not line:match("^%s*$") then
      vim.api.nvim_feedkeys(default_key, "n", false)
      return
    end
    local row = vim.fn.line(".")
    local target_indent = 0
    for r = row - 1, 1, -1 do
      local prev = vim.fn.getline(r)
      if not prev:match("^%s*$") then
        target_indent = vim.fn.indent(r)
        if prev:match("[{(%[]%s*$") or prev:match(":%s*$") then
          target_indent = target_indent + vim.bo.shiftwidth
        end
        break
      end
    end
    if target_indent > 0 then
      vim.api.nvim_set_current_line(string.rep(" ", target_indent))
      vim.api.nvim_win_set_cursor(0, { row, target_indent })
    end
    vim.cmd("startinsert!")
  end
end
vim.keymap.set("n", "i", smart_insert("i"))
vim.keymap.set("n", "a", smart_insert("a"))
