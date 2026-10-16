-- Loaded only inside VSCode (vscode-neovim). Mirrors the terminal keymaps with VSCode commands.
local vscode = require("vscode")

-- No which-key popup here to hold the prefix open, so give leader sequences more time.
vim.opt.timeoutlen = 3000

local function map(lhs, command)
  vim.keymap.set("n", lhs, function()
    vscode.action(command)
  end)
end

map("<leader>ff", "workbench.action.quickOpen")
map("<leader>fg", "workbench.action.findInFiles")
map("<leader>fb", "workbench.action.showAllEditors")
map("<leader>fs", "workbench.action.gotoSymbol")
map("<leader>fd", "workbench.actions.view.problems")
map("<leader><leader>", "workbench.action.openRecent")

map("<leader>gd", "editor.action.revealDefinition")
map("<leader>gr", "editor.action.goToReferences")
map("<leader>gi", "editor.action.goToImplementation")
map("<leader>ca", "editor.action.quickFix")
map("<leader>rn", "editor.action.rename")
map("<leader>gf", "editor.action.formatDocument")
map("[d", "editor.action.marker.prev")
map("]d", "editor.action.marker.next")
map("<leader>cd", "editor.action.showHover")

map("<S-h>", "workbench.action.previousEditor")
map("<S-l>", "workbench.action.nextEditor")
map("<leader>bc", "workbench.action.closeActiveEditor")
for i = 1, 5 do
  map("<leader>" .. i, "workbench.action.openEditorAtIndex" .. i)
end

map("<C-h>", "workbench.action.navigateLeft")
map("<C-j>", "workbench.action.navigateDown")
map("<C-k>", "workbench.action.navigateUp")
map("<C-l>", "workbench.action.navigateRight")
map("<leader>e", "workbench.action.toggleSidebarVisibility")

map("<leader>x", "workbench.action.debug.run")
map("<leader>md", "markdown.showPreviewToSide")

vim.keymap.set("n", "<leader>i", function()
  local key = "editor.guides.indentation"
  vscode.update_config(key, not vscode.get_config(key), "global")
end)
