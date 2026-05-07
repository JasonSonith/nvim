local M = {}

local state = { theme = "catppuccin", transparent = true }

local registry = {
  catppuccin = {
    colorscheme = "catppuccin-mocha",
    setup = function(o) require("themes.catppuccin").setup(o) end,
  },
  kanagawa = {
    colorscheme = "kanagawa",
    setup = function(o) require("themes.kanagawa").setup(o) end,
  },
  vscode = {
    colorscheme = "vscode",
    setup = function(o) require("themes.vscode").setup(o) end,
  },
  ["rose-pine"] = {
    colorscheme = "rose-pine",
    setup = function(o) require("themes.rose_pine").setup(o) end,
  },
}

local function persist_path()
  return vim.fn.stdpath("data") .. "/theme.json"
end

local function load_persisted()
  local ok, data = pcall(function()
    local f = io.open(persist_path(), "r")
    if not f then return nil end
    local content = f:read("*a")
    f:close()
    return vim.json.decode(content)
  end)
  if ok and type(data) == "table" then
    if registry[data.theme] then state.theme = data.theme end
    if type(data.transparent) == "boolean" then state.transparent = data.transparent end
  end
end

local function save()
  pcall(function()
    local f = io.open(persist_path(), "w")
    if not f then return end
    f:write(vim.json.encode(state))
    f:close()
  end)
end

function M.set(name)
  local entry = registry[name]
  if not entry then
    vim.notify("Unknown theme: " .. tostring(name), vim.log.levels.ERROR)
    return
  end
  entry.setup({ transparent = state.transparent })
  vim.cmd.colorscheme(entry.colorscheme)
  state.theme = name
  save()
  vim.notify("Theme: " .. name)
end

function M.toggle_transparency()
  state.transparent = not state.transparent
  local entry = registry[state.theme]
  entry.setup({ transparent = state.transparent })
  vim.cmd.colorscheme(entry.colorscheme)
  save()
  vim.notify("Transparency: " .. (state.transparent and "on" or "off"))
end

function M.setup()
  load_persisted()
  local entry = registry[state.theme]
  entry.setup({ transparent = state.transparent })
  vim.cmd.colorscheme(entry.colorscheme)

  local map = vim.keymap.set
  map("n", "<leader>uc", function() M.set("catppuccin") end, { desc = "Theme: Catppuccin" })
  map("n", "<leader>uk", function() M.set("kanagawa")   end, { desc = "Theme: Kanagawa" })
  map("n", "<leader>uv", function() M.set("vscode")     end, { desc = "Theme: VSCode" })
  map("n", "<leader>ur", function() M.set("rose-pine")  end, { desc = "Theme: Rose Pine" })
  map("n", "<leader>ub", function() M.toggle_transparency() end, { desc = "Toggle background transparency" })
end

return M
