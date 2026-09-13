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

    -- nvim-treesitter (master) registers its predicates with `all = false`,
    -- which Neovim 0.12 dropped: handlers now always receive a list of nodes,
    -- so `kind-eq?` throws and every indentexpr call that hits it returns 0.
    -- Symptom: pressing <CR> inside a JS/TS block snaps the new line to
    -- column 0. Re-register it list-aware.
    require("nvim-treesitter.query_predicates")
    vim.treesitter.query.add_predicate("kind-eq?", function(match, _, _, pred)
      local node = match[pred[2]]
      if type(node) == "table" then
        node = node[1]
      end
      if not node then
        return true
      end
      return vim.list_contains({ unpack(pred, 3) }, node:type())
    end, { force = true })
  end,
}
