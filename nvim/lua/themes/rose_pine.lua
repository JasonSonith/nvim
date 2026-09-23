local M = {}

function M.setup(opts)
  opts = opts or {}
  local transparent = opts.transparent
  if transparent == nil then transparent = true end
  require("rose-pine").setup({ styles = { transparency = transparent } })
end

return M
