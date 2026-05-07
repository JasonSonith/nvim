# Theme switcher with `<leader>u…` bindings

**Date:** 2026-05-07
**Status:** approved

## Summary

Add three colorscheme plugins (kanagawa, rose-pine, vscode) alongside the existing catppuccin, and a small orchestration module that exposes one keymap per theme plus a transparency toggle:

- `<leader>uc` → catppuccin (mocha)
- `<leader>uk` → kanagawa
- `<leader>uv` → vscode
- `<leader>ur` → rose-pine
- `<leader>ub` → toggle background transparency for the active theme

Selected theme and transparency state persist across restarts via a JSON file under `stdpath("data")`. Default first-launch state preserves today's behavior: `catppuccin-mocha` with transparency on.

## Motivation

Single-theme dotfiles. The user wants to swap looks on the fly without editing files, and wants a way to disable the transparent background per session (e.g. when projecting on a screen, or to compare a theme's intended palette against its transparent rendering).

## Architecture

Two layers, with a deliberate split:

1. **Plugin specs** (`nvim/lua/plugins/<theme>.lua`) — minimal lazy.nvim entries. They install the plugin and load it eagerly. They do **not** call `setup()`; they have no `config` field.
2. **Theme modules** (`nvim/lua/themes/<theme>.lua`) — own all configuration. Each exposes a single function `M.setup({ transparent = bool })`. The orchestrator (`nvim/lua/themes/init.lua`) dispatches to them and is also where keymaps and persistence live.

Why the split: lazy.nvim's `config` only fires once per session. The transparency toggle needs to re-run setup at runtime with a new value. Pulling setup into a plain Lua module makes startup and runtime toggle go through the *same* code path with no duplicated configuration.

## Files touched

| File | Change |
|---|---|
| `nvim/lua/themes/init.lua` | **new** — orchestrator: registry, state, `setup`, `set`, `toggle_transparency`, persistence, keymap registration |
| `nvim/lua/themes/catppuccin.lua` | **new** — moves the existing setup logic out of `plugins/catppuccin.lua` and exposes `M.setup({ transparent })` |
| `nvim/lua/themes/kanagawa.lua` | **new** — adapter, `M.setup({ transparent })` calls `require("kanagawa").setup({ transparent = ... })` |
| `nvim/lua/themes/rose_pine.lua` | **new** — adapter; passes `disable_background = not transparent` (rose-pine inverts the option name) |
| `nvim/lua/themes/vscode.lua` | **new** — adapter; passes `transparent = transparent` |
| `nvim/lua/plugins/catppuccin.lua` | **edit** — slim down to install-only spec; remove `config`, `setup` body, autocmd |
| `nvim/lua/plugins/kanagawa.lua` | **new** — `{ "rebelot/kanagawa.nvim", lazy = false }` |
| `nvim/lua/plugins/rose-pine.lua` | **new** — `{ "rose-pine/neovim", name = "rose-pine", lazy = false }` |
| `nvim/lua/plugins/vscode.lua` | **new** — `{ "Mofiqul/vscode.nvim", name = "vscode", lazy = false }` |
| `nvim/lua/plugins/which-key.lua` | **edit** — add `<leader>u` group + 5 desc entries to `spec` |
| `nvim/init.lua` | **edit** — add `require("themes").setup()` between `lazy.setup` and `require("highlights")` |
| `nvim/lazy-lock.json` | auto-changed by `:Lazy sync`; committed per repo convention |

## Orchestrator API (`nvim/lua/themes/init.lua`)

```lua
local M = {}

local state = { theme = "catppuccin", transparent = true }

local registry = {
  catppuccin    = { colorscheme = "catppuccin-mocha", setup = function(o) require("themes.catppuccin").setup(o) end },
  kanagawa      = { colorscheme = "kanagawa",         setup = function(o) require("themes.kanagawa").setup(o)   end },
  vscode        = { colorscheme = "vscode",           setup = function(o) require("themes.vscode").setup(o)     end },
  ["rose-pine"] = { colorscheme = "rose-pine",        setup = function(o) require("themes.rose_pine").setup(o)  end },
}

function M.setup()         -- called once from init.lua
function M.set(name)       -- switch active theme; saves state
function M.toggle_transparency()  -- flip transparent flag; re-applies; saves

return M
```

`M.setup()` flow:
1. `load_persisted()` — read `stdpath("data") .. "/theme.json"`, validate, populate `state` (silent fall-through to defaults on any failure).
2. Look up `registry[state.theme]`.
3. Call its `setup({ transparent = state.transparent })`.
4. `vim.cmd.colorscheme(entry.colorscheme)`.
5. Register the five `<leader>u…` keymaps (see below).
6. No save (nothing changed).

`M.set(name)` flow:
1. Look up entry; if `nil`, `vim.notify("Unknown theme: "..name, vim.log.levels.ERROR)` and return.
2. `entry.setup({ transparent = state.transparent })`.
3. `vim.cmd.colorscheme(entry.colorscheme)`.
4. `state.theme = name; save()`.
5. `vim.notify("Theme: "..name)`.

`M.toggle_transparency()` flow:
1. `state.transparent = not state.transparent`.
2. Re-run `registry[state.theme].setup({ transparent = state.transparent })`.
3. `vim.cmd.colorscheme(...)` again to force re-application (some plugins need this to pick up setup-time options).
4. `save()`.
5. `vim.notify("Transparency: " .. (state.transparent and "on" or "off"))`.

## Per-theme adapter contract

All four expose the same one-function interface so the orchestrator stays uniform:

```lua
-- themes/kanagawa.lua
local M = {}
function M.setup(opts)
  require("kanagawa").setup({ transparent = opts.transparent })
end
return M
```

```lua
-- themes/vscode.lua
local M = {}
function M.setup(opts)
  require("vscode").setup({ transparent = opts.transparent })
end
return M
```

```lua
-- themes/rose_pine.lua
local M = {}
function M.setup(opts)
  require("rose-pine").setup({ disable_background = not opts.transparent })
end
return M
```

The point of the adapter layer is to absorb each plugin's per-vendor option name (`transparent_background`, `transparent`, `disable_background`) so the orchestrator only ever knows about a single boolean.

## Catppuccin refactor

The current `nvim/lua/plugins/catppuccin.lua` (~123 lines) does three things in `config`:

1. Calls `require("catppuccin").setup({...})` with a large `custom_highlights` table.
2. Calls `vim.cmd.colorscheme("catppuccin-mocha")`.
3. Registers a `ColorScheme` autocmd that re-applies mocha-palette overrides.

Two issues if left as-is:

- **Autocmd would clobber other themes.** It currently fires on every `:colorscheme` event. After switching to kanagawa, it would still apply mocha colors over kanagawa's highlights. Fix: register the autocmd with `pattern = "catppuccin*"` so it only fires for catppuccin colorschemes (matches `catppuccin-mocha`, `-frappe`, etc.).
- **Setup logic can't be re-run.** It lives inside `config = function() ... end`, which lazy.nvim only invokes once. Fix: move it into `nvim/lua/themes/catppuccin.lua` exposing `M.setup(opts)`.

**New `nvim/lua/themes/catppuccin.lua`** — same setup body as today, with these changes:
- Take `opts.transparent` (default `true` if missing) and pass it as `transparent_background = opts.transparent`.
- Inside `custom_highlights`, conditionally include the `bg = "NONE"` entries only when `opts.transparent` is true. When transparent is off, drop the NONE entries so catppuccin's native panel backgrounds show through cleanly.
- Move the `apply_overrides()` function and its initial call here.
- Move the `ColorScheme` autocmd here, **adding `pattern = "catppuccin*"`** to gate it.
- Inside `apply_overrides()`, gate the `bg = panel_bg` lines for floating windows on `opts.transparent` so that toggling off doesn't leave double-painted backgrounds.

**Slimmed `nvim/lua/plugins/catppuccin.lua`** becomes ~6 lines:

```lua
return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,
}
```

No `config` field. Setup happens via the orchestrator after `lazy.setup` returns. Keeping `priority = 1000` so catppuccin sorts ahead of any future plugin that might depend on a colorscheme being available at load.

The catppuccin **flavour** stays `mocha`. Adding macchiato/frappe/latte as additional `<leader>u…` entries is a trivial follow-up but is out of scope here — the user asked for "the catppuccin theme" (singular).

## Persistence

**Path:** `vim.fn.stdpath("data") .. "/theme.json"` — resolves to `~/.local/share/nvim/theme.json`. Per-machine state, sits next to lazy.nvim's own data, gitignored by default.

**Format:**
```json
{ "theme": "kanagawa", "transparent": false }
```

**Read** (`load_persisted`):
```lua
local path = vim.fn.stdpath("data") .. "/theme.json"
local ok, data = pcall(function()
  local f = io.open(path, "r"); if not f then return nil end
  local content = f:read("*a"); f:close()
  return vim.json.decode(content)
end)
if ok and type(data) == "table" then
  if registry[data.theme] then state.theme = data.theme end
  if type(data.transparent) == "boolean" then state.transparent = data.transparent end
end
```

**Write** (`save`):
```lua
local f = io.open(path, "w"); if not f then return end
f:write(vim.json.encode(state)); f:close()
```

`pcall`-wrapped on read; silent on write failure (no point blocking an edit if disk is full).

**Defaults if file missing:** `theme = "catppuccin"`, `transparent = true`. Matches today's behavior.

**Edge cases:**

| Case | Behavior |
|------|----------|
| First run (no file) | Use defaults, no error, no file write yet |
| Malformed JSON | Use defaults, ignore file silently |
| File names a theme not in registry (e.g. user removed `kanagawa.lua`) | Fall back to default theme; transparency value still applied if valid |
| `transparent` field missing or non-boolean | Fall back to `true` |
| `vim.cmd.colorscheme(name)` errors (plugin missing) | Let the error surface — that's a real installation problem, not something to swallow |
| Disk write fails on save | Silent; theme switch still works for the session |

No migration logic needed; no prior persistence file exists.

## Keymaps

Registered inside `M.setup()` after persisted state loads:

```lua
local map = vim.keymap.set
map("n", "<leader>uc", function() M.set("catppuccin") end, { desc = "Theme: Catppuccin" })
map("n", "<leader>uk", function() M.set("kanagawa")   end, { desc = "Theme: Kanagawa" })
map("n", "<leader>uv", function() M.set("vscode")     end, { desc = "Theme: VSCode" })
map("n", "<leader>ur", function() M.set("rose-pine")  end, { desc = "Theme: Rose Pine" })
map("n", "<leader>ub", function() M.toggle_transparency() end, { desc = "Toggle background transparency" })
```

Each keymap wraps the call in a closure (rather than passing `M.set` directly) so loading order issues surface as clear errors instead of `nil` argument confusion.

## which-key spec entries

Add to the `spec` table in `nvim/lua/plugins/which-key.lua`, appended after the existing `<leader>T` entry (the table's current last entry):

```lua
{ "<leader>u",  group = "ui / theme" },
{ "<leader>uc", desc = "Catppuccin" },
{ "<leader>uk", desc = "Kanagawa" },
{ "<leader>uv", desc = "VSCode" },
{ "<leader>ur", desc = "Rose Pine" },
{ "<leader>ub", desc = "Toggle transparency" },
```

The keymap call sites also set `desc`, but the central `spec` table is the documented convention for this repo (per CLAUDE.md "Cross-file invariants").

## init.lua change

One line added between `lazy.setup` and `require("highlights")`:

```lua
require("vim-options")
require("lazy").setup("plugins")
require("themes").setup()      -- new
require("highlights")
```

**Order matters.** `themes.setup()` must run **after** `lazy.setup` (so all theme plugins are loaded and their colorscheme commands are registered) and **before** `require("highlights")` (so the `LineNr`/`CursorLineNr` overrides land on top of whatever theme just got applied — same relative ordering as today).

## Plugin specs (the three new ones)

```lua
-- nvim/lua/plugins/kanagawa.lua
return { "rebelot/kanagawa.nvim", lazy = false }

-- nvim/lua/plugins/rose-pine.lua
return { "rose-pine/neovim", name = "rose-pine", lazy = false }

-- nvim/lua/plugins/vscode.lua
return { "Mofiqul/vscode.nvim", name = "vscode", lazy = false }
```

Why each line:

- `lazy = false` on all three so their `:colorscheme` commands are registered before `themes.setup()` runs. Cost: ~3 small Lua plugins parsed at startup; negligible.
- No `priority` set — they don't need to beat anything; only catppuccin needs `priority = 1000`.
- `name = "rose-pine"` overrides lazy's default inferred name (`neovim`) so the require path matches what the rose-pine plugin actually exposes.
- `name = "vscode"` overrides the inferred `vscode.nvim` to the require path the plugin uses (`require("vscode")`).

## Behavior summary

1. Fresh nvim install (no theme.json): catppuccin-mocha loads, transparent. Identical to today.
2. `<space>uk` → kanagawa loads with current transparency setting; theme.json written.
3. `<space>ub` → transparency flips; current theme re-applied; theme.json updated.
4. nvim restart → theme.json read, last theme + transparency restored.
5. `<space>` alone → which-key popup shows the `u` group with 5 entries.
6. User deletes theme.json → next launch falls back to catppuccin transparent.

## Out of scope

- **Catppuccin flavour switcher** — `<leader>uc` always loads `catppuccin-mocha`. Adding `<leader>uc{m,f,l,c}` for the four flavours is a one-screen follow-up; left out to keep the surface small.
- **Per-theme custom highlights for kanagawa/vscode/rose-pine** — these load with their stock looks. The catppuccin custom_highlights apply only to catppuccin (gated by autocmd pattern). If the user later wants Telescope/Mason/float styling unified across themes, that's a bigger palette-mapping project and gets its own spec.
- **Picker-style switcher** — explicitly rejected during brainstorming. Four dedicated keymaps win on speed.
- **Lazy-loading inactive themes** — possible via `keys = {...}` event triggering, but adds startup-vs-toggle code paths and complicates the orchestrator. Not worth it for ~50ms saved.
- **Random / cycle keymap** — not requested. Easy to add later as `M.next()` if wanted.

## Verification

No automated test suite per CLAUDE.md. Manual checks after applying changes and running `:Lazy sync`:

1. **Install** — `nvim --headless "+Lazy! sync" "+qa"` exits 0; `git diff nvim/lazy-lock.json` shows new entries for `kanagawa.nvim`, `rose-pine`, `vscode.nvim` with pinned commits.
2. **Default state** — open nvim. Confirm catppuccin-mocha loads (statusline + Telescope panels look unchanged from before this change). Background is transparent.
3. **Switch each theme** — press `<space>uk`, `<space>uv`, `<space>ur`, `<space>uc` in turn. After each: confirm a `vim.notify` flash with the theme name; statusline / cursorline / strings render in the expected new palette; no error messages in `:messages`.
4. **Transparency toggle** — on each theme, press `<space>ub`. Confirm: background switches between transparent (terminal bg shows through) and opaque (theme's own bg color visible). Press again, confirm it flips back. No leftover NONE-painted regions.
5. **catppuccin autocmd gating** — switch to kanagawa, then run `:colorscheme kanagawa` again manually. Confirm catppuccin's mocha overrides do NOT re-apply (Telescope panels stay kanagawa-colored, not catppuccin-mantle).
6. **Persistence** — switch to kanagawa with transparency off. Quit nvim. Relaunch. Confirm kanagawa loads with opaque background. Inspect `~/.local/share/nvim/theme.json` to confirm `{"theme":"kanagawa","transparent":false}`.
7. **Persistence fallback** — `rm ~/.local/share/nvim/theme.json`. Relaunch nvim. Confirm catppuccin transparent loads (defaults). No error messages.
8. **Persistence corruption** — `echo "garbage" > ~/.local/share/nvim/theme.json`. Relaunch nvim. Confirm catppuccin transparent loads. No error messages.
9. **which-key** — press `<space>` alone, wait for popup. Confirm a `u` entry labeled "ui / theme" exists, and pressing `u` reveals the five sub-entries with their descs.
10. **Catppuccin still feels right** — on catppuccin specifically, confirm Telescope panels, Mason window, completion popup, LSP info window, and floating diagnostics still match the customized look from before this change (i.e. the refactor is behavior-preserving for catppuccin).

## Risks

- **Transparency toggle visual glitch on first flip** — some plugins (catppuccin in particular) may need a *second* `:colorscheme` re-apply to fully refresh after `setup()` is re-called. The orchestrator does call `vim.cmd.colorscheme(...)` after every `setup()`, which should be sufficient, but if not, the fallback is to also do a `vim.cmd("redraw!")`. Verifiable in step 4 of Verification.
- **rose-pine option name confusion** — rose-pine uses `disable_background` (inverted polarity) instead of `transparent`. The adapter at `themes/rose_pine.lua` handles the inversion explicitly. Tested in step 4.
- **Plugin upstream rename** — if `rebelot/kanagawa.nvim` or `Mofiqul/vscode.nvim` rename their main module, the adapter `require("kanagawa")` / `require("vscode")` calls would break. lazy-lock.json pins commits, so this only bites on a manual `:Lazy update`. Easy to spot and fix.
- **Reversibility** — full revert is one `git revert` of the implementation commit. Persistence file (`~/.local/share/nvim/theme.json`) is harmless if left behind after revert.
