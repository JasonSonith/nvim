return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        integrations = {
          neotree = true,
          telescope = true,
          treesitter = true,
          gitsigns = true,
          mason = true,
          native_lsp = { enabled = true },
          cmp = true,
          bufferline = true,
        },
        custom_highlights = function(colors)
          local panel_bg = colors.mantle
          return {
            Normal = { bg = "NONE" },
            NormalNC = { bg = "NONE" },
            SignColumn = { bg = "NONE" },
            VertSplit = { bg = "NONE" },
            WinSeparator = { bg = "NONE" },
            TabLine = { bg = "NONE" },
            TabLineFill = { bg = "NONE" },
            EndOfBuffer = { bg = "NONE" },
            NeoTreeNormal = { bg = "NONE" },
            NeoTreeNormalNC = { bg = "NONE" },
            NeoTreeEndOfBuffer = { bg = "NONE" },
            BufferLineFill = { bg = "NONE" },

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
          }
        end,
      })
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
}
