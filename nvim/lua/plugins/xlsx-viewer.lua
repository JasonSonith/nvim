-- View .xlsx workbooks as aligned CSV tables.
-- Pipes the file through `xlsx2csv` on read, displays in a read-only buffer with
-- ft=csv, which lazy-loads csvview.nvim for column alignment + cell navigation.

-- Vim ships zipPlugin.vim, which registers a BufReadCmd for *.xlsx (xlsx is a zip).
-- That autocmd loads after init.lua, so it runs *after* ours and clobbers the
-- buffer. Skip the whole zip plugin — user can re-enable with `:unlet g:loaded_zipPlugin`.
vim.g.loaded_zipPlugin = 1
vim.g.loaded_zip = 1

local function convert(path, sheet)
  local sheet_arg
  if type(sheet) == "number" then
    sheet_arg = "-s " .. sheet
  else
    sheet_arg = "-n " .. vim.fn.shellescape(sheet)
  end
  local cmd = string.format("xlsx2csv %s %s", sheet_arg, vim.fn.shellescape(path))
  local lines = vim.fn.systemlist(cmd)
  return lines, vim.v.shell_error
end

local function load_xlsx(buf, path, sheet)
  if vim.fn.executable("xlsx2csv") == 0 then
    vim.notify("xlsx2csv not found. Install with: pip3 install --user xlsx2csv", vim.log.levels.ERROR)
    return
  end
  local lines, err = convert(path, sheet)
  if err ~= 0 then
    vim.notify("xlsx2csv failed:\n" .. table.concat(lines, "\n"), vim.log.levels.ERROR)
    return
  end
  vim.bo[buf].modifiable = true
  vim.bo[buf].readonly = false
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
  vim.bo[buf].filetype = "csv"
  vim.b[buf].xlsx_path = path
  vim.b[buf].xlsx_sheet = sheet
end

local group = vim.api.nvim_create_augroup("XlsxView", { clear = true })
vim.api.nvim_create_autocmd("BufReadCmd", {
  group = group,
  pattern = { "*.xlsx", "*.xlsm" },
  callback = function(ev)
    local path = vim.fn.fnamemodify(ev.match, ":p")
    load_xlsx(ev.buf, path, vim.b[ev.buf].xlsx_sheet or 1)
  end,
})

vim.api.nvim_create_user_command("XlsxSheet", function(opts)
  local path = vim.b.xlsx_path
  if not path then
    vim.notify("Not in an xlsx-derived buffer", vim.log.levels.WARN)
    return
  end
  local sheet = tonumber(opts.args) or opts.args
  load_xlsx(0, path, sheet)
end, { nargs = 1, desc = "Reload current xlsx buffer with given sheet (number or name)" })

vim.api.nvim_create_user_command("XlsxSheets", function()
  local path = vim.b.xlsx_path
  if not path then
    vim.notify("Not in an xlsx-derived buffer", vim.log.levels.WARN)
    return
  end
  local out = vim.fn.systemlist("xlsx2csv -p '|' -a " .. vim.fn.shellescape(path) .. " 2>&1 | head -50")
  -- Fallback: list sheets via python
  if vim.v.shell_error ~= 0 then
    out = vim.fn.systemlist(string.format(
      [[python3 -c "from openpyxl import load_workbook; print('\n'.join(load_workbook(%q, read_only=True).sheetnames))"]],
      path))
  end
  vim.notify("Sheets:\n" .. table.concat(out, "\n"), vim.log.levels.INFO)
end, { desc = "List sheets in current xlsx buffer" })

return {
  "hat0uma/csvview.nvim",
  ft = { "csv", "tsv" },
  opts = {
    view = { display_mode = "border" },
  },
  config = function(_, opts)
    local csvview = require("csvview")
    csvview.setup(opts)
    local function safe_enable(buf)
      if not csvview.is_enabled(buf) then csvview.enable(buf) end
    end
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "csv", "tsv" },
      callback = function(ev) safe_enable(ev.buf) end,
    })
    if vim.tbl_contains({ "csv", "tsv" }, vim.bo.filetype) then
      safe_enable(0)
    end
  end,
}
