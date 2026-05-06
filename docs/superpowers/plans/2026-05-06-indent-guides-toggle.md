# Indent guides with `<leader>i` toggle — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `lukas-reineke/indent-blankline.nvim` (ibl v3) to the nvim config with both static per-level guides and current-scope highlighting, off by default, toggled by `<leader>i`.

**Architecture:** Three small file changes — one new plugin spec under `nvim/lua/plugins/` (lazy.nvim auto-discovers it), one integration line in catppuccin's setup so guide colors match the palette, one which-key spec entry so the popup labels the binding. No tests in this repo (per `CLAUDE.md`); verification is headless syntax/load checks plus a manual UX checklist.

**Tech Stack:** Neovim ≥ 0.10, lazy.nvim plugin manager, catppuccin colorscheme, which-key.nvim, indent-blankline.nvim v3.

**Spec:** `docs/superpowers/specs/2026-05-06-indent-guides-toggle-design.md` (commit `4f7eb7c`).

---

## File map

| File | Status | What it does after this plan |
|---|---|---|
| `nvim/lua/plugins/indent-blankline.lua` | **new** | Single lazy.nvim spec for ibl. Loads on `BufReadPost`/`BufNewFile`. Starts disabled. Exposes `<leader>i` toggle. |
| `nvim/lua/plugins/catppuccin.lua` | edit | Adds one line `indent_blankline = { enabled = true }` to the `integrations` table so ibl highlight groups get palette-derived colors. |
| `nvim/lua/plugins/which-key.lua` | edit | Adds one line `{ "<leader>i", desc = "Toggle indent guides" }` to the `spec` table so the popup labels the binding. |
| `nvim/lazy-lock.json` | auto | Gets a new pinned commit hash for `indent-blankline.nvim` after `:Lazy sync`. Committed alongside Task 1 per repo convention. |

---

## Task 1: Add the indent-blankline plugin spec and install it

**Files:**
- Create: `nvim/lua/plugins/indent-blankline.lua`
- Modify (auto): `nvim/lazy-lock.json`

- [ ] **Step 1: Sanity-check baseline — nvim launches cleanly today**

Run from the repo root:

```bash
nvim --headless "+qa" 2>&1
```

Expected: no output, exit code 0. (If anything is printed before the change, capture it as the baseline so you can distinguish new errors from pre-existing ones.)

- [ ] **Step 2: Create the plugin spec file**

Create `nvim/lua/plugins/indent-blankline.lua` with exactly this content:

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

Notes for context (do not include in the file):
- `main = "ibl"` is required — ibl's setup module is `require("ibl")`, not the repo name.
- `event = { "BufReadPost", "BufNewFile" }` is intentional: lazy-loading via `keys` would cause the first press to load the plugin (which auto-enables guides on `setup()`) and then immediately toggle them off, producing a "first press does nothing visible" bug.
- `opts.enabled = false` is passed to ibl's setup so guides start off. ibl 3.x supports this top-level flag.

- [ ] **Step 3: Install the plugin via headless lazy sync**

Run from the repo root:

```bash
nvim --headless "+Lazy! sync" "+qa" 2>&1
```

Expected: lazy prints install lines for `indent-blankline.nvim` (and possibly other plugins it brings up to date), then exits 0. No Lua errors. If you see a Lua error mentioning `ibl` or `indent-blankline`, stop and re-check Step 2's content.

- [ ] **Step 4: Verify the lockfile picked up the new plugin**

Run:

```bash
git diff nvim/lazy-lock.json
```

Expected: a diff that adds an `"indent-blankline.nvim": { "branch": "master", "commit": "<hash>" }` block. (If `:Lazy sync` updated other plugins as a side effect, those entries may also appear — that is fine; they get committed together per repo convention.)

- [ ] **Step 5: Verify the plugin loads without errors**

Force-load ibl in a headless run to catch any setup-time errors that would only fire when an event triggers:

```bash
nvim --headless "+lua require('ibl').setup({ enabled = false })" "+qa" 2>&1
```

Expected: no output, exit 0. A Lua error here means the spec or ibl version has a problem to fix before continuing.

- [ ] **Step 6: Commit Task 1**

```bash
git -C /home/Jason/nvim add nvim/lua/plugins/indent-blankline.lua nvim/lazy-lock.json
git -C /home/Jason/nvim commit -m "$(cat <<'EOF'
nvim: add indent-blankline.nvim with <leader>i toggle

Loads on BufReadPost/BufNewFile, starts disabled, toggles via :IBLToggle.
Scope highlighting pre-armed so it activates with the main toggle.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 2: Wire catppuccin's ibl integration

**Files:**
- Modify: `nvim/lua/plugins/catppuccin.lua` (line 18 — inside the `integrations = { ... }` table, immediately after `bufferline = true,`)

- [ ] **Step 1: Read the current state of the integrations table**

Confirm the file still matches the expected baseline before editing:

```bash
sed -n '10,20p' /home/Jason/nvim/nvim/lua/plugins/catppuccin.lua
```

Expected output:

```
      integrations = {
        neotree = true,
        telescope = true,
        treesitter = true,
        gitsigns = true,
        mason = true,
        native_lsp = { enabled = true },
        cmp = true,
        bufferline = true,
      },
```

(If the table has drifted, adjust Step 2's `old_string` to match the current content.)

- [ ] **Step 2: Add the ibl integration line**

Edit `nvim/lua/plugins/catppuccin.lua` — insert `indent_blankline = { enabled = true },` as the last entry of the `integrations` table.

`old_string`:

```
        cmp = true,
        bufferline = true,
      },
```

`new_string`:

```
        cmp = true,
        bufferline = true,
        indent_blankline = { enabled = true },
      },
```

- [ ] **Step 3: Verify nvim launches cleanly with the integration**

```bash
nvim --headless "+qa" 2>&1
```

Expected: no output, exit 0. (catppuccin's integration table is permissive — registering a key for a plugin that isn't loaded yet is a no-op.)

- [ ] **Step 4: Verify the highlight groups are wired up**

```bash
nvim --headless "+lua print(vim.inspect(vim.api.nvim_get_hl(0, { name = 'IblIndent' })))" "+qa" 2>&1
```

Expected: a non-empty Lua table with at least an `fg` field, e.g. `{ fg = 4540116 }`. An empty table `{}` means the integration didn't take effect and Step 2 should be re-checked. (`IblScope` will only populate after ibl is loaded by an event, so checking only `IblIndent` is enough here.)

- [ ] **Step 5: Commit Task 2**

```bash
git -C /home/Jason/nvim add nvim/lua/plugins/catppuccin.lua
git -C /home/Jason/nvim commit -m "$(cat <<'EOF'
nvim: enable catppuccin's indent_blankline integration

Registers IblIndent/IblScope/IblWhitespace with palette-derived colors so
indent guides match the mocha theme instead of falling back to a generic
Whitespace color against the transparent background.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 3: Register `<leader>i` in which-key's spec

**Files:**
- Modify: `nvim/lua/plugins/which-key.lua` (line 26 — in the `spec` table, between `<leader>h` and `<leader>w`)

- [ ] **Step 1: Read the current spec block**

```bash
sed -n '24,28p' /home/Jason/nvim/nvim/lua/plugins/which-key.lua
```

Expected output:

```
      { "<leader>e", desc = "Toggle file tree" },
      { "<leader>h", desc = "Clear search highlight" },
      { "<leader>w", desc = "Save file" },
      { "<leader>q", desc = "Quit" },
      { "<leader>l", desc = "Run last test" },
```

(If lines have drifted, adjust Step 2's `old_string` accordingly.)

- [ ] **Step 2: Add the new entry between `<leader>h` and `<leader>w`**

Edit `nvim/lua/plugins/which-key.lua`.

`old_string`:

```
      { "<leader>h", desc = "Clear search highlight" },
      { "<leader>w", desc = "Save file" },
```

`new_string`:

```
      { "<leader>h", desc = "Clear search highlight" },
      { "<leader>i", desc = "Toggle indent guides" },
      { "<leader>w", desc = "Save file" },
```

- [ ] **Step 3: Verify nvim launches cleanly**

```bash
nvim --headless "+qa" 2>&1
```

Expected: no output, exit 0.

- [ ] **Step 4: Commit Task 3**

```bash
git -C /home/Jason/nvim add nvim/lua/plugins/which-key.lua
git -C /home/Jason/nvim commit -m "$(cat <<'EOF'
nvim: register <leader>i in which-key spec

Labels the indent-guides toggle in the which-key popup so it surfaces
under <Space> alongside the other leader-letter bindings.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 4: End-to-end manual verification

**Files:** none modified.

This task is the spec's verification checklist. It must be performed in an interactive nvim session — there is no automated test suite. Do not commit anything in this task; it is acceptance testing.

- [ ] **Step 1: Default-off check**

Open `nvim/init.lua` in a real terminal:

```bash
nvim /home/Jason/nvim/nvim/init.lua
```

Expected: no vertical lines at indent columns. The buffer looks identical to before this feature.

- [ ] **Step 2: Toggle on**

Inside that nvim session, press `<Space>i`.

Expected:
- Thin vertical lines (`│`) appear at every indent level across the visible buffer.
- The scope containing the cursor is drawn in a distinct color and has an underline on the line that opens the scope.

- [ ] **Step 3: Toggle off**

Press `<Space>i` again.

Expected: all guide lines and the scope underline disappear immediately. The buffer returns to the Step 1 state.

- [ ] **Step 4: which-key popup shows the binding**

Press `<Space>` alone and wait ~300 ms (the configured which-key delay).

Expected: the popup contains a row labeled `i → Toggle indent guides`.

Press `<Esc>` to dismiss.

- [ ] **Step 5: Cross-window (global toggle) check**

Inside the nvim session, run:

```vim
:vsp /home/Jason/nvim/nvim/lua/plugins/which-key.lua
```

Press `<Space>i` once. Expected: guides appear in **both** windows simultaneously (proves the toggle is global, not buffer-local).

Press `<Space>i` again. Expected: guides disappear in both windows.

- [ ] **Step 6: Persistence-of-absence check**

Quit nvim (`:qa`) and relaunch:

```bash
nvim /home/Jason/nvim/nvim/init.lua
```

Expected: guides start **off** again. State does not persist across restarts.

- [ ] **Step 7: Health check**

Inside nvim run:

```vim
:checkhealth
```

Expected: no new failures attributable to indent-blankline. (`:checkhealth ibl` may not exist; an absence of errors anywhere mentioning ibl is the pass condition.)

- [ ] **Step 8: Final state confirmation**

Run from the shell:

```bash
git -C /home/Jason/nvim log --oneline -4
```

Expected output (most recent first):

```
<sha> nvim: register <leader>i in which-key spec
<sha> nvim: enable catppuccin's indent_blankline integration
<sha> nvim: add indent-blankline.nvim with <leader>i toggle
4f7eb7c docs: spec for indent-guides toggle (<leader>i)
```

If any of Steps 1–7 fails, do not mark this task complete. Diagnose, fix the offending earlier task with a follow-up commit, and re-run the failing step.

---

## Spec coverage check (for the implementer)

Cross-reference of spec sections to tasks:

| Spec section | Implemented in |
|---|---|
| Plugin spec details (`main`, `event`, `opts`, `keys`) | Task 1 Step 2 |
| `nvim/lazy-lock.json` update | Task 1 Step 3–4 |
| which-key spec entry | Task 3 Step 2 |
| catppuccin integration | Task 2 Step 2 |
| Behavior summary (default off, toggle on, toggle off, restart) | Task 4 Steps 1–6 |
| Verification: install / health / default off / toggle on / toggle off / which-key / cross-window / persistence-of-absence | Task 4 Steps 1–7 |
| Out-of-scope items (filetype exclusions, buffer-local, persistence, scope-only sub-toggle, custom char) | Intentionally not implemented — do not add. |
