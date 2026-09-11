return {
  "windwp/nvim-ts-autotag",
  ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "vue", "markdown" },
  config = function()
    require("nvim-ts-autotag").setup()
  end,
}
