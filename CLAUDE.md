# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repo purpose

Personal Neovim + tmux dotfiles. `install.sh` symlinks `nvim/` → `~/.config/nvim` and `tmux/tmux.conf` → `~/.tmux.conf`, so **editing files in this repo directly modifies the user's live editor config** — there is no build step, the repo *is* the deployed config. There are no tests.

## Plugin architecture

`nvim/init.lua` calls `require("lazy").setup("plugins")`. lazy.nvim auto-discovers every file under `nvim/lua/plugins/`; each file returns one plugin spec (or a list of specs).

- **Add a plugin = add a new file in `nvim/lua/plugins/`.** Don't register specs anywhere else.
- `nvim/lua/plugins.lua` (the file) is intentionally `return {}` — the `plugins/` directory shadows it. Don't put specs in it.
- `nvim/lazy-lock.json` is committed (pinned versions across machines). After a spec change, run `:Lazy sync` and commit the lockfile diff.

## Reload after editing

| Change | Reload |
|---|---|
| New/edited file under `nvim/lua/plugins/` | `:Lazy sync` (or `nvim --headless "+Lazy! sync" "+qa"`) |
| Treesitter parser config | `:TSUpdateSync` |
| `tmux/tmux.conf` | `prefix r` in tmux (prefix is `Ctrl-a`, not `Ctrl-b`) |
| Lua under `nvim/lua/` | Restart nvim, or `:source %` |

## Cross-file invariants

- **Tmux ↔ nvim pane nav** is split between `tmux/tmux.conf` and `nvim/lua/plugins/nvim-tmux-navigation.lua`. Both bind `Ctrl-h/j/k/l` *and* `Alt-h/j/k/l` (Alt is a fallback because some terminals send `Ctrl-h` as Backspace). Change one side, change the other.
- **Catppuccin highlight overrides** in `nvim/lua/plugins/catppuccin.lua` are applied twice: first via `custom_highlights`, then imperatively in a `ColorScheme` autocmd. The autocmd is load-bearing — some plugins re-apply highlights after `setup()` and would clobber the first pass. Don't remove it.
- **`ensure_installed` lists** are independent in `lsp-config.lua` (mason-lspconfig) and `treesitter.lua`. Adding a language usually means editing both.
- **Leader keymaps**: declare new `<leader>`-prefixed groups/descriptions in `which-key.lua`'s `spec` so the popup stays accurate. Leader is `<Space>`.

## Formatting

`none-ls` provides `stylua` (Lua) and `prettier` (JS/TS/etc.), bound to `<leader>gf`. Add new formatters in `nvim/lua/plugins/none-ls.lua` and make sure the binary exists (Mason or system).

## Treesitter

Python parser is pinned to the `master` branch revision (`parser_config.python.install_info.revision = "master"` in `treesitter.lua`), and `nvim/queries/python/highlights.scm` ships a custom highlight query that overrides the upstream one.

## install.sh gotchas

- Detects apt / dnf / pacman; on apt, **skips installing nodejs/npm if a node ≥18 is already on PATH** (apt's npm conflicts with NodeSource installs — adding both makes apt fail with unsatisfiable dependencies).
- Requires Neovim ≥ 0.10; older/missing → downloads the latest release tarball and links `/usr/local/bin/nvim`. Version comparison is numeric (string compare gets `0.11` < `0.9` wrong).
- Pre-existing `~/.config/nvim` and `~/.tmux.conf` are backed up to `*.bak.<timestamp>` before symlinking — never silently overwrites.
