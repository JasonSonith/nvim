return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  config = function()
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.python.install_info.revision = "master"

    -- Common fence aliases (replaces nvim-treesitter's broken
    -- `set-lang-from-info-string!` directive; see queries/markdown/injections.scm).
    vim.treesitter.language.register("bash", { "sh", "zsh" })
    vim.treesitter.language.register("python", { "py" })
    vim.treesitter.language.register("javascript", { "js" })
    vim.treesitter.language.register("typescript", { "ts" })
    vim.treesitter.language.register("markdown", { "md" })

    require("nvim-treesitter.configs").setup({
      ensure_installed = { "lua", "vim", "vimdoc", "bash", "c", "python", "javascript", "typescript", "html", "css", "json", "markdown", "markdown_inline" },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
