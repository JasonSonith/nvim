return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = { enabled = true },
  config = function(_, opts)
    require("render-markdown").setup(opts)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function(ev)
        vim.keymap.set("n", "<leader>md", "<cmd>RenderMarkdown toggle<cr>",
          { buffer = ev.buf, silent = true, desc = "Toggle markdown read/edit" })
      end,
    })
  end,
}
