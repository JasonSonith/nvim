return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
      },
    })

    vim.keymap.set("n", "<leader>gf", function()
      local has_null_ls = #vim.lsp.get_clients({ bufnr = 0, name = "null-ls" }) > 0
      vim.lsp.buf.format({
        filter = function(client)
          return not has_null_ls or client.name == "null-ls"
        end,
      })
    end, { desc = "Format buffer" })
  end,
}
