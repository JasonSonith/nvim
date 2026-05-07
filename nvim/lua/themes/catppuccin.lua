local M = {}

function M.setup(opts)
  opts = opts or {}
  local transparent = opts.transparent
  if transparent == nil then transparent = true end

  require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = transparent,
    integrations = {
      neotree = true,
      telescope = true,
      treesitter = true,
      gitsigns = true,
      mason = true,
      native_lsp = { enabled = true },
      cmp = true,
      bufferline = true,
      indent_blankline = { enabled = true },
    },
    custom_highlights = function(colors)
      local panel_bg = colors.mantle
      local out = {
        StatusLine = { bg = panel_bg, fg = colors.text },
        StatusLineNC = { bg = panel_bg, fg = colors.overlay0 },

        NormalFloat = { bg = panel_bg },
        FloatBorder = { bg = panel_bg, fg = colors.blue },
        FloatTitle = { bg = panel_bg, fg = colors.lavender },

        TelescopeNormal = { bg = panel_bg },
        TelescopeBorder = { bg = panel_bg, fg = colors.blue },
        TelescopeTitle = { bg = panel_bg, fg = colors.lavender },
        TelescopePromptNormal = { bg = colors.surface0 },
        TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
        TelescopePromptTitle = { bg = colors.surface0, fg = colors.lavender },
        TelescopePreviewNormal = { bg = panel_bg },
        TelescopePreviewBorder = { bg = panel_bg, fg = colors.blue },
        TelescopeResultsNormal = { bg = panel_bg },
        TelescopeResultsBorder = { bg = panel_bg, fg = colors.blue },
        TelescopeSelection = { bg = colors.surface0 },

        Pmenu = { bg = panel_bg, fg = colors.text },
        PmenuSel = { bg = colors.surface1, fg = colors.text },
        PmenuSbar = { bg = panel_bg },
        PmenuThumb = { bg = colors.overlay0 },

        WhichKeyFloat = { bg = panel_bg },
        WhichKeyBorder = { bg = panel_bg, fg = colors.blue },

        MasonNormal = { bg = panel_bg },
        MasonHeader = { bg = panel_bg, fg = colors.lavender },
        MasonHighlight = { fg = colors.blue },
        MasonHighlightBlock = { bg = colors.surface0, fg = colors.text },
        MasonHighlightBlockBold = { bg = colors.surface0, fg = colors.text, bold = true },
        MasonMuted = { fg = colors.overlay0 },
        MasonMutedBlock = { bg = colors.surface0, fg = colors.overlay1 },

        LspInfoBorder = { bg = panel_bg, fg = colors.blue },
        LspInfoTitle = { bg = panel_bg, fg = colors.lavender },
        LspInfoFiletype = { bg = panel_bg, fg = colors.yellow },
        LspInfoTip = { bg = panel_bg, fg = colors.overlay1 },
        LspInfoList = { bg = panel_bg, fg = colors.green },

        DiagnosticFloatingError = { bg = panel_bg, fg = colors.red },
        DiagnosticFloatingWarn = { bg = panel_bg, fg = colors.yellow },
        DiagnosticFloatingInfo = { bg = panel_bg, fg = colors.sky },
        DiagnosticFloatingHint = { bg = panel_bg, fg = colors.teal },
        DiagnosticFloatingOk = { bg = panel_bg, fg = colors.green },
      }
      if transparent then
        out.Normal = { bg = "NONE" }
        out.NormalNC = { bg = "NONE" }
        out.SignColumn = { bg = "NONE" }
        out.VertSplit = { bg = "NONE" }
        out.WinSeparator = { bg = "NONE" }
        out.TabLine = { bg = "NONE" }
        out.TabLineFill = { bg = "NONE" }
        out.EndOfBuffer = { bg = "NONE" }
        out.NeoTreeNormal = { bg = "NONE" }
        out.NeoTreeNormalNC = { bg = "NONE" }
        out.NeoTreeEndOfBuffer = { bg = "NONE" }
        out.BufferLineFill = { bg = "NONE" }
      end
      return out
    end,
  })

  local function apply_overrides()
    local C = require("catppuccin.palettes").get_palette("mocha")
    local set = vim.api.nvim_set_hl

    set(0, "DiagnosticUnderlineError", { undercurl = true, underline = true, sp = C.red })
    set(0, "DiagnosticUnderlineWarn",  { undercurl = true, underline = true, sp = C.yellow })
    set(0, "DiagnosticUnderlineInfo",  { undercurl = true, underline = true, sp = C.sky })
    set(0, "DiagnosticUnderlineHint",  { undercurl = true, underline = true, sp = C.teal })
    set(0, "DiagnosticUnderlineOk",    { undercurl = true, underline = true, sp = C.green })

    if transparent then
      local panel_bg = C.mantle
      local cmp_bg, cmp_sel_bg = "#0f1729", "#1e2a4a"
      set(0, "NormalFloat", { bg = panel_bg, blend = 0 })
      set(0, "FloatBorder", { bg = panel_bg, fg = C.blue, blend = 0 })
      set(0, "FloatTitle", { bg = panel_bg, fg = C.lavender, blend = 0 })
      set(0, "Pmenu", { bg = panel_bg, fg = C.text, blend = 0 })
      set(0, "PmenuSel", { bg = C.surface1, fg = C.text, blend = 0 })
      set(0, "CmpFloat", { bg = cmp_bg, fg = C.text, blend = 0 })
      set(0, "CmpFloatSel", { bg = cmp_sel_bg, fg = C.text, blend = 0 })
      set(0, "MasonNormal", { bg = panel_bg })
      set(0, "LspInfoBorder", { bg = panel_bg, fg = C.blue })
      set(0, "DiagnosticFloatingError", { bg = panel_bg, fg = C.red })
      set(0, "DiagnosticFloatingWarn", { bg = panel_bg, fg = C.yellow })
      set(0, "DiagnosticFloatingInfo", { bg = panel_bg, fg = C.sky })
      set(0, "DiagnosticFloatingHint", { bg = panel_bg, fg = C.teal })
      set(0, "DiagnosticFloatingOk", { bg = panel_bg, fg = C.green })
    end
  end

  apply_overrides()

  local group = vim.api.nvim_create_augroup("CatppuccinThemeOverrides", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    pattern = "catppuccin*",
    callback = apply_overrides,
  })
end

return M
