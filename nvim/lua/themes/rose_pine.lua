local M = {}

function M.setup(opts)
  opts = opts or {}
  local transparent = opts.transparent
  if transparent == nil then transparent = true end
  require("rose-pine").setup({ disable_background = not transparent })
end

return M
