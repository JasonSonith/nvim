# Indent guides with `<leader>i` toggle

**Date:** 2026-05-06
**Status:** approved

## Summary

Add `lukas-reineke/indent-blankline.nvim` (ibl v3) to the nvim config, configured to render both static per-level indent guides and a current-scope highlight. Guides start **off** at startup; `<leader>i` toggles them on and off globally for the session.

## Motivation

No indent visualization exists in the current config. The user wants on-demand indent guides for inspecting deeply nested code, with a single leader-key toggle so the buffer stays clean by default.

## Plugin choice

`indent-blankline.nvim` over alternatives:
- vs. `mini.indentscope`: ibl shows guides at every level (the standard "indent guide" look), not just the current scope. User picked the layered "static + scope" style.
- vs. `hlchunk.nvim`: ibl is the de-facto standard, has a built-in `:IBLToggle` command, and a maintained catppuccin integration.

## Files touched

| File | Change |
|---|---|
| `nvim/lua/plugins/indent-blankline.lua` | **new** — single lazy.nvim spec returning the plugin config |
| `nvim/lua/plugins/which-key.lua` | edit — add `{ "<leader>i", desc = "Toggle indent guides" }` to `spec` |
| `nvim/lua/plugins/catppuccin.lua` | edit — add `indent_blankline = { enabled = true }` to `integrations` |
| `nvim/lazy-lock.json` | auto-changed by `:Lazy sync`; committed per repo convention |

## Plugin spec details

```lua
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    enabled = false,
    scope = { enabled = true, show_start = true, show_end = false },
  },
  keys = {
    { "<leader>i", "<cmd>IBLToggle<cr>", desc = "Toggle indent guides" },
  },
}
```

Why each line:

- `main = "ibl"` — ibl's setup module is `require("ibl")`, not the repo name. Lazy needs this hint.
- `event = { "BufReadPost", "BufNewFile" }` — eager-enough loading. Loading via `keys` instead would cause a first-press bug: the key would load the plugin (auto-enables guides on `setup()`) and *then* run `IBLToggle` (turns them off), so the first press would appear to do nothing visible.
- `opts.enabled = false` — passed through to ibl's setup so guides start disabled. ibl 3.x supports this top-level flag in the options table.
- `opts.scope.enabled = true` — pre-arms the scope highlight so it activates the moment the user toggles guides on. `show_start = true` (ibl default) draws an underline on the line that opens the scope; `show_end = false` skips the closing-line underline (less visual noise). Both are tweakable later without re-architecting.
- `keys` — single global toggle. `<cmd>IBLToggle<cr>` calls ibl's user command, which flips `enabled` for all windows. State persists for the session, resets to off on next nvim launch.

## which-key spec entry

Add to the `spec` table in `nvim/lua/plugins/which-key.lua` (alphabetically grouped with sibling letter-keys, e.g. between `<leader>h` and `<leader>w`):

```lua
{ "<leader>i", desc = "Toggle indent guides" },
```

This lets the which-key popup label the binding correctly. The plugin spec's `keys[].desc` *also* labels it, but the central `spec` table is the documented convention in this repo (see CLAUDE.md, "Cross-file invariants").

## catppuccin integration

Add one line to the `integrations = { ... }` table in `nvim/lua/plugins/catppuccin.lua`:

```lua
indent_blankline = { enabled = true },
```

This registers `IblIndent`, `IblScope`, and `IblWhitespace` highlight groups with palette-derived colors so the guides look at home in catppuccin-mocha. Without it, ibl falls back to a generic `Whitespace` color that may clash with the transparent background.

The existing `ColorScheme` autocmd in `catppuccin.lua` is unaffected — it only re-applies the `LineNr`/`Pmenu`/`Diagnostic*` overrides, none of which collide with ibl's groups.

## Behavior summary

1. nvim opens → no guides visible (because `enabled = false`).
2. User opens any normal file → ibl loads silently in the background (no visual change, since disabled).
3. `<space>i` → guides appear at every indent level + scope underline on the current block.
4. `<space>i` again → all gone.
5. `<space>` alone (which-key popup) → shows "Toggle indent guides" next to `i`.
6. nvim restart → back to step 1.

## Out of scope

- **Filetype exclusions** — ibl's defaults already skip `help`, `lazy`, `dashboard`, and similar non-code buffers. No custom exclude list needed.
- **Buffer-local toggle** — global toggle is the simpler mental model and matches "feature on/off".
- **Persistence across restarts** — always starts off. Adding a `vim.g`-backed cache would be premature.
- **Scope-only sub-toggle** (`:IBLToggleScope`) — one toggle is enough; if the user later wants to disable just the scope highlight while keeping per-level guides, they can flip `scope.enabled` in the spec.
- **Custom indent character** — ibl's default `│` is fine. Customizable later via `opts.indent.char` without changing the keymap or toggle.

## Verification

No automated test suite per `CLAUDE.md`. Manual checks after applying the changes and running `:Lazy sync`:

1. **Install** — `nvim --headless "+Lazy! sync" "+qa"` exits 0; `git diff nvim/lazy-lock.json` shows a new `indent-blankline.nvim` entry with a pinned commit.
2. **Health** — open nvim, run `:checkhealth`, confirm nothing new is reported as broken.
3. **Default off** — open `nvim/init.lua` in nvim, confirm no vertical lines appear at indent columns.
4. **Toggle on** — press `<space>i`. Confirm: (a) thin vertical lines at every indent level across the visible buffer, (b) the scope containing the cursor has a distinct color and an underline on its opening line.
5. **Toggle off** — press `<space>i` again. Confirm all lines disappear.
6. **which-key** — press `<space>` alone, wait for the popup, confirm an `i` entry labeled "Toggle indent guides" is visible.
7. **Cross-window** — open a second file in a vertical split (`:vsp other.lua`), toggle guides on once, confirm guides show in *both* windows simultaneously (proves the toggle is global, not buffer-local).
8. **Persistence-of-absence** — quit and relaunch nvim, confirm guides start off again.

## Risks

- **First-press latency** — the very first `<space>i` after nvim launch may have a one-frame delay because ibl was lazy-loaded on `BufReadPost`, but its first scope computation runs on toggle. Acceptable; not visible in practice.
- **Highlight clash with transparent background** — `transparent_background = true` in catppuccin means `IblWhitespace` could render against `NONE`. The catppuccin integration sets a foreground-only override, so this is safe, but if guides look invisible in some terminal, we'd revisit by setting an explicit `IblIndent` color in the catppuccin `custom_highlights` block.
- **Reversibility** — full revert is one `git revert` of the implementation commit. No data, no migration.
