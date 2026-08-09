# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repo purpose

Personal Neovim + tmux dotfiles. `install.sh` symlinks `nvim/` → `~/.config/nvim` and `tmux/tmux.conf` → `~/.tmux.conf`, so **editing files in this repo directly modifies the user's live editor config** — there is no build step, the repo *is* the deployed config. There are no tests.

## Plugin architecture

`nvim/init.lua` calls `require("lazy").setup("plugins")`. lazy.nvim auto-discovers every file under `nvim/lua/plugins/`; each file returns one plugin spec (or a list of specs).

- **Add a plugin = add a new file in `nvim/lua/plugins/`.** Don't register specs anywhere else.
- `nvim/lua/plugins.lua` (the file) is intentionally `return {}` — the `plugins/` directory shadows it. Don't put specs in it.
- `nvim/lazy-lock.json` is committed (pinned versions across machines). After a spec change, run `:Lazy sync` and commit the lockfile diff.

## Tmux plugins (TPM)

`tmux.conf` declares plugins via `@plugin` lines. `install.sh` clones TPM to `~/.tmux/plugins/tpm` and runs `bin/install_plugins`; `tmux.conf` also self-bootstraps TPM (clones on first tmux launch if missing). Inside tmux: `prefix + I` installs new plugins, `prefix + U` updates them.

Active plugins:
- **tmux-resurrect** — manual save (`prefix + Ctrl-s`) / restore (`prefix + Ctrl-r`). Captures pane contents; restores nvim sessions when a `Session.vim` is present in the pane's cwd (`@resurrect-strategy-nvim 'session'`).
- **tmux-continuum** — auto-saves every 15 min and auto-restores on tmux server start (`@continuum-restore 'on'`). After a reboot, just run `tmux` and the previous session comes back.

The `run '~/.tmux/plugins/tpm/tpm'` line at the bottom of `tmux.conf` must stay last — anything below it is loaded before TPM and won't see plugin-provided commands.

## Reload after editing

| Change | Reload |
|---|---|
| New/edited file under `nvim/lua/plugins/` | `:Lazy sync` (or `nvim --headless "+Lazy! sync" "+qa"`) |
| Treesitter parser config | `:TSUpdateSync` |
| `tmux/tmux.conf` | `prefix r` in tmux (prefix is `Ctrl-a`, not `Ctrl-b`) |
| New `@plugin` line in `tmux.conf` | `prefix + I` in tmux, or `~/.tmux/plugins/tpm/bin/install_plugins` |
| Lua under `nvim/lua/` | Restart nvim, or `:source %` |

## Cross-file invariants

- **Tmux ↔ nvim pane nav** is split between `tmux/tmux.conf` and `nvim/lua/plugins/nvim-tmux-navigation.lua`. Both bind `Ctrl-h/k/l` *and* `Alt-h/j/k/l` (Alt is a fallback because some terminals send `Ctrl-h` as Backspace). `C-j` is intentionally bound only on the nvim side — tmux leaves it alone so shells can use it to submit multiline input; use `M-j` for pane-down outside nvim. Change one side, change the other.
- **Catppuccin highlight overrides** in `nvim/lua/plugins/catppuccin.lua` are applied twice: first via `custom_highlights`, then imperatively in a `ColorScheme` autocmd. The autocmd is load-bearing — some plugins re-apply highlights after `setup()` and would clobber the first pass. Don't remove it.
- **`ensure_installed` lists** are independent in `lsp-config.lua` (mason-lspconfig) and `treesitter.lua`. Adding a language usually means editing both.
- **Leader keymaps**: declare new `<leader>`-prefixed groups/descriptions in `which-key.lua`'s `spec` so the popup stays accurate. Leader is `<Space>`.

## Formatting

`none-ls` provides `stylua` (Lua) and `prettier` (JS/TS/etc.), bound to `<leader>gf`. Add new formatters in `nvim/lua/plugins/none-ls.lua` and make sure the binary exists (Mason or system).

## Treesitter

Python parser is pinned to the `master` branch revision (`parser_config.python.install_info.revision = "master"` in `treesitter.lua`), and `nvim/queries/python/highlights.scm` ships a custom highlight query that overrides the upstream one. `nvim/queries/python/indents.scm` likewise overrides nvim-treesitter's indent query, which doesn't compile against the master parser (a broken indent query makes every new Python line indent to column 0).

## install.sh gotchas

- Detects apt / dnf / pacman; on apt, **skips installing nodejs/npm if a node ≥18 is already on PATH** (apt's npm conflicts with NodeSource installs — adding both makes apt fail with unsatisfiable dependencies).
- Requires Neovim ≥ 0.10; older/missing → downloads the latest release tarball and links `/usr/local/bin/nvim`. Version comparison is numeric (string compare gets `0.11` < `0.9` wrong).
- Pre-existing `~/.config/nvim` and `~/.tmux.conf` are backed up to `*.bak.<timestamp>` before symlinking — never silently overwrites.
