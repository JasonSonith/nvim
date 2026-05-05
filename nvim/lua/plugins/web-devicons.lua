-- Glyphs encoded as raw UTF-8 byte escapes so they survive editor copy-paste.
-- All chosen from the nf-fa-* range (U+F000-U+F2FF), which is in every
-- Nerd Font release from v1.x onward — won't break on older fonts.
local FILE_EXCEL = "\xef\x87\x83" -- U+F1C3 nf-fa-file_excel_o
local FILE_TABLE = "\xef\x83\x8e" -- U+F0CE nf-fa-table
local FILE_LIST  = "\xef\x80\xa2" -- U+F022 nf-fa-list_alt

return {
  "nvim-tree/nvim-web-devicons",
  lazy = false,
  priority = 1000,
  opts = {
    default = true,
    override_by_extension = {
      xlsx = { icon = FILE_EXCEL, color = "#207245", name = "Xlsx" },
      xls  = { icon = FILE_EXCEL, color = "#207245", name = "Xls" },
      xlsm = { icon = FILE_EXCEL, color = "#207245", name = "Xlsm" },
      csv  = { icon = FILE_TABLE, color = "#89e051", name = "Csv" },
      tsv  = { icon = FILE_TABLE, color = "#89e051", name = "Tsv" },
      log  = { icon = FILE_LIST,  color = "#9ca3af", name = "Log" },
    },
  },
}
