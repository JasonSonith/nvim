return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = {
        timeout = 3000,
        render = "compact",
        stages = "fade",
        -- Fade blends into Normal's bg, which transparent themes leave unset.
        background_colour = function()
          local bg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg
          return bg and string.format("#%06x", bg) or "#000000"
        end,
      },
    },
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
    routes = {
      { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
    },
  },
  keys = {
    { "<leader>nh", "<cmd>Noice history<cr>", desc = "Message history" },
    { "<leader>nd", "<cmd>Noice dismiss<cr>", desc = "Dismiss messages" },
  },
}
