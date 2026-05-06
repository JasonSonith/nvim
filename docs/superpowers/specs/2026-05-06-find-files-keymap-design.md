# Find-files keymap: `<C-p>` → `<leader>ff`

**Date:** 2026-05-06
**Status:** approved

## Summary

Move the telescope `find_files` binding from `<C-p>` to `<leader>ff` so it slots under the existing `<leader>f` ("find") group, alongside `<leader>fg` (live grep) and `<leader><leader>` (oldfiles).

## Motivation

`<leader>f*` is already declared as the "find" group in `nvim/lua/plugins/which-key.lua:13`, but the file finder lives outside that namespace at `<C-p>`. Moving it under `<leader>ff`:

- Surfaces it in the which-key popup next to its sibling find-actions.
- Frees up `<C-p>` for future use.
- Removes the only `<C-p>` binding in the repo (verified — no other references).

## Change

Single edit in `nvim/lua/plugins/telescope.lua:25`:

```diff
- vim.keymap.set("n", "<C-p>", builtin.find_files, {})
+ vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
```

The `desc` field lets which-key label it correctly without needing a separate spec entry.

## Out of scope

- Alpha dashboard buttons.
- Search-within-file (`current_buffer_fuzzy_find`).
- Neo-tree keymap additions (built-ins `a`/`d`/`r`/`f`/`?` already cover the user's stated wants).
- Documentation updates — `grep -rn "C-p"` across the repo found no references outside `telescope.lua:25`.

## Verification

After editing:

1. `nvim --headless -c "lua local f, e = loadfile(vim.fn.stdpath('config') .. '/lua/plugins/telescope.lua'); if not f then error(e) end" -c qa` — syntax check.
2. Open nvim, press `<leader>` and confirm the which-key popup shows `ff → Find files` under the `find` group.
3. Press `<leader>ff` and confirm telescope's find_files picker opens.
4. Press `<C-p>` and confirm it does nothing (no leftover binding).

## Risks

- Muscle memory: a few days of pressing `<C-p>` before `<leader>ff` sticks. Reversible by reverting the one-line diff.
