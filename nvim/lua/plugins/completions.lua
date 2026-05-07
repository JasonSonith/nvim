return {
  {
    "hrsh7th/cmp-nvim-lsp"
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      local cmp_enabled = true

      cmp.setup({
        enabled = function()
          if vim.bo.filetype == "neo-tree-popup" then
            return false
          end
          return cmp_enabled
        end,
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered({
            winhighlight = "Normal:CmpFloat,FloatBorder:FloatBorder,CursorLine:CmpFloatSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            winhighlight = "Normal:CmpFloat,FloatBorder:FloatBorder,Search:None",
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping(function(fallback)
            local line = vim.api.nvim_get_current_line()
            local col = vim.fn.col(".")
            local prev = line:sub(col - 1, col - 1)
            local next_ = line:sub(col, col)
            local pairs_map = { ["{"] = "}", ["("] = ")", ["["] = "]" }
            if pairs_map[prev] == next_ then
              if cmp.visible() then cmp.close() end
              local row = vim.fn.line(".")
              local indent = vim.fn.indent(row)
              local sw = vim.bo.shiftwidth
              local before = line:sub(1, col - 1)
              local after = line:sub(col)
              vim.api.nvim_buf_set_lines(0, row - 1, row, false, {
                before,
                string.rep(" ", indent + sw),
                string.rep(" ", indent) .. after,
              })
              vim.api.nvim_win_set_cursor(0, { row + 1, indent + sw })
              return
            end
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ select = false })
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" }, -- For luasnip users.
        }, {
          { name = "buffer" },
        }),
      })

      vim.keymap.set("n", "<leader>cv", function()
        cmp_enabled = not cmp_enabled
        vim.notify("Completion " .. (cmp_enabled and "ON" or "OFF"))
      end, { desc = "Toggle code suggestions" })
    end,
  },
}
