# Theme switcher with `<leader>u…` bindings — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add three colorscheme plugins (kanagawa, rose-pine, vscode) alongside the existing catppuccin, plus a small orchestration module that exposes `<leader>uc/uk/uv/ur` to switch themes and `<leader>ub` to toggle background transparency, with both pieces of state persisted across nvim restarts.

**Architecture:** Two layers. Plugin specs (`nvim/lua/plugins/<theme>.lua`) only install plugins eagerly — no `config`. Theme modules (`nvim/lua/themes/<theme>.lua`) own configuration: each exposes `M.setup({ transparent })`. The orchestrator (`nvim/lua/themes/init.lua`) holds a registry, persists state to `~/.local/share/nvim/theme.json`, and registers keymaps. Catppuccin's existing 110-line setup body moves into `nvim/lua/themes/catppuccin.lua` (the plugin spec is slimmed to install-only). Both startup and runtime toggle go through the same `setup({ transparent })` code path so configuration never drifts.

**Tech Stack:** Neovim ≥ 0.10, lazy.nvim, catppuccin (already installed), kanagawa.nvim (rebelot), rose-pine/neovim, vscode.nvim (Mofiqul), which-key.nvim.

**Spec:** `docs/superpowers/specs/2026-05-07-theme-switcher-design.md` (commit `525db5c`).

**Refinement vs spec:** The spec says to gate the catppuccin `ColorScheme` autocmd with `pattern = "catppuccin*"`. Implementation also wraps it in a named augroup with `clear = true` so re-running `setup()` (which happens on every theme switch and transparency toggle) replaces the old autocmd instead of accumulating duplicates. Same intent, just the safe way to do it.

---

## File map

| File | Status | What it does after this plan |
|---|---|---|
| `nvim/lua/plugins/kanagawa.lua` | **new** | Install-only spec for `rebelot/kanagawa.nvim`, `lazy = false`. |
| `nvim/lua/plugins/rose-pine.lua` | **new** | Install-only spec for `rose-pine/neovim`, `name = "rose-pine"`, `lazy = false`. |
| `nvim/lua/plugins/vscode.lua` | **new** | Install-only spec for `Mofiqul/vscode.nvim`, `name = "vscode"`, `lazy = false`. |
| `nvim/lua/themes/kanagawa.lua` | **new** | Adapter — exposes `M.setup({ transparent })`, calls `require("kanagawa").setup(...)`. |
| `nvim/lua/themes/rose_pine.lua` | **new** | Adapter — inverts polarity (`disable_background = not transparent`). |
| `nvim/lua/themes/vscode.lua` | **new** | Adapter for vscode plugin. |
| `nvim/lua/themes/catppuccin.lua` | **new** | Holds catppuccin's full setup body (moved from `plugins/catppuccin.lua`), takes a `transparent` parameter, gates `bg = "NONE"` overrides on it, gates the `ColorScheme` autocmd by `pattern = "catppuccin*"` inside an augroup. |
| `nvim/lua/themes/init.lua` | **new** | Orchestrator — registry, state, persistence, `M.set(name)`, `M.toggle_transparency()`, `M.setup()`, registers the five `<leader>u…` keymaps. |
| `nvim/lua/plugins/catppuccin.lua` | edit | Slimmed to ~6 lines (install spec only); `config` body removed and moved to `nvim/lua/themes/catppuccin.lua`. |
| `nvim/init.lua` | edit | One new line: `require("themes").setup()` between `lazy.setup("plugins")` and `require("highlights")`. |
| `nvim/lua/plugins/which-key.lua` | edit | Six new entries appended to the `spec` table (one group + five description entries). |
| `nvim/lazy-lock.json` | auto | Gets new pinned commits for kanagawa, rose-pine, vscode; committed alongside Task 1 per repo convention. |

---

## Task 1: Install the three new colorscheme plugins

**Files:**
- Create: `nvim/lua/plugins/kanagawa.lua`
- Create: `nvim/lua/plugins/rose-pine.lua`
- Create: `nvim/lua/plugins/vscode.lua`
- Modify (auto): `nvim/lazy-lock.json`

After this task: the three colorscheme commands (`:colorscheme kanagawa`, `rose-pine`, `vscode`) are usable. No keymaps wired yet. Default theme on launch is still catppuccin-mocha (unchanged).

- [ ] **Step 1: Sanity-check baseline — nvim launches cleanly today**

```bash
nvim --headless "+qa" 2>&1
```

Expected: no output, exit 0. (If something prints, capture it as the baseline so you can distinguish new errors later.)

- [ ] **Step 2: Create the kanagawa plugin spec**

Create `nvim/lua/plugins/kanagawa.lua` with exactly this content:

```lua
return { "rebelot/kanagawa.nvim", lazy = false }
```

Notes for context (do not include in the file):
- `lazy = false` ensures the colorscheme command is registered before `themes.setup()` runs in a later task.
- No `priority` set — only catppuccin needs `priority = 1000`. Other themes don't need to beat anything in load order.
- No `name` override needed; the plugin's require path (`require("kanagawa")`) matches the inferred default.

- [ ] **Step 3: Create the rose-pine plugin spec**

Create `nvim/lua/plugins/rose-pine.lua` with exactly this content:

```lua
return { "rose-pine/neovim", name = "rose-pine", lazy = false }
```

Notes for context:
- `name = "rose-pine"` overrides lazy's default inferred name (`neovim`). Without this, `require("rose-pine")` and `:colorscheme rose-pine` would not be discoverable under their canonical names.

- [ ] **Step 4: Create the vscode plugin spec**

Create `nvim/lua/plugins/vscode.lua` with exactly this content:

```lua
return { "Mofiqul/vscode.nvim", name = "vscode", lazy = false }
```

Notes for context:
- `name = "vscode"` overrides the inferred name `vscode.nvim` so the require path matches what the plugin exposes.

- [ ] **Step 5: Install all three via headless lazy sync**

```bash
nvim --headless "+Lazy! sync" "+qa" 2>&1
```

Expected: lazy prints install lines for `kanagawa.nvim`, `rose-pine`, `vscode.nvim` (and possibly other plugins it brings up to date), then exits 0. No Lua errors. If you see an error mentioning any of the three plugin names, stop and re-check Steps 2–4.

- [ ] **Step 6: Verify the lockfile picked up the three plugins**

```bash
git diff nvim/lazy-lock.json
```

Expected: the diff adds three entries — `"kanagawa.nvim"`, `"rose-pine"`, `"vscode.nvim"` — each with a `branch` and `commit` field. If `:Lazy sync` updated other plugins as a side effect, those entries may also appear; that is fine and gets committed together per repo convention.

- [ ] **Step 7: Verify each new colorscheme actually loads**

Run all three in turn:

```bash
nvim --headless "+colorscheme kanagawa" "+lua print(vim.g.colors_name)" "+qa" 2>&1
nvim --headless "+colorscheme rose-pine" "+lua print(vim.g.colors_name)" "+qa" 2>&1
nvim --headless "+colorscheme vscode" "+lua print(vim.g.colors_name)" "+qa" 2>&1
```

Expected for each: prints the colorscheme name (e.g. `kanagawa`) and exits 0. A Lua error or empty output means the plugin install or the spec is wrong — re-check Steps 2–5.

- [ ] **Step 8: Verify catppuccin still loads as default**

```bash
nvim --headless "+lua print(vim.g.colors_name)" "+qa" 2>&1
```

Expected: prints `catppuccin-mocha`. (At this point `plugins/catppuccin.lua` is still the unchanged version that calls `vim.cmd.colorscheme("catppuccin-mocha")` in its config.)

- [ ] **Step 9: Commit Task 1**

```bash
git add nvim/lua/plugins/kanagawa.lua nvim/lua/plugins/rose-pine.lua nvim/lua/plugins/vscode.lua nvim/lazy-lock.json
git commit -m "$(cat <<'EOF'
nvim: install kanagawa, rose-pine, vscode colorscheme plugins

Adds three install-only specs alongside catppuccin. All eager-loaded so
their colorscheme commands are available before the theme orchestrator
runs in a later commit. No keymaps wired yet; default theme unchanged.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 2: Add the three thin adapter modules

**Files:**
- Create: `nvim/lua/themes/kanagawa.lua`
- Create: `nvim/lua/themes/rose_pine.lua`
- Create: `nvim/lua/themes/vscode.lua`

After this task: each theme can be configured (with a transparency parameter) by calling `require("themes.<name>").setup({ transparent = bool })`. Nothing calls these yet — they're loadable but inert.

The `nvim/lua/themes/` directory does not exist yet; the first `Write` will create it implicitly.

- [ ] **Step 1: Create the kanagawa adapter**

Create `nvim/lua/themes/kanagawa.lua` with exactly this content:

```lua
local M = {}

function M.setup(opts)
  opts = opts or {}
  local transparent = opts.transparent
  if transparent == nil then transparent = true end
  require("kanagawa").setup({ transparent = transparent })
end

return M
```

Notes for context:
- `opts.transparent` defaults to `true` if missing (orchestrator always passes it; the default is for safety against direct callers).
- `require("kanagawa").setup` accepts `transparent = bool`; that's all kanagawa needs to honor the spec's transparency contract.

- [ ] **Step 2: Create the vscode adapter**

Create `nvim/lua/themes/vscode.lua` with exactly this content:

```lua
local M = {}

function M.setup(opts)
  opts = opts or {}
  local transparent = opts.transparent
  if transparent == nil then transparent = true end
  require("vscode").setup({ transparent = transparent })
end

return M
```

- [ ] **Step 3: Create the rose-pine adapter**

Create `nvim/lua/themes/rose_pine.lua` (note the underscore in the filename — Lua module naming convention; the plugin spec keeps the hyphen) with exactly this content:

```lua
local M = {}

function M.setup(opts)
  opts = opts or {}
  local transparent = opts.transparent
  if transparent == nil then transparent = true end
  require("rose-pine").setup({ disable_background = not transparent })
end

return M
```

Notes for context:
- The file name `rose_pine.lua` uses an underscore so the require path is `require("themes.rose_pine")`. The plugin spec at `nvim/lua/plugins/rose-pine.lua` keeps the hyphen, matching both the existing one-file-per-plugin filename style and the plugin's own require name (`require("rose-pine")`).
- rose-pine inverts the polarity: its option is `disable_background`, not `transparent`. The adapter absorbs this so the orchestrator only ever knows a single boolean.

- [ ] **Step 4: Verify each adapter is loadable and runs without errors**

```bash
nvim --headless "+lua require('themes.kanagawa').setup({transparent=true})" "+qa" 2>&1
nvim --headless "+lua require('themes.kanagawa').setup({transparent=false})" "+qa" 2>&1
nvim --headless "+lua require('themes.vscode').setup({transparent=true})" "+qa" 2>&1
nvim --headless "+lua require('themes.vscode').setup({transparent=false})" "+qa" 2>&1
nvim --headless "+lua require('themes.rose_pine').setup({transparent=true})" "+qa" 2>&1
nvim --headless "+lua require('themes.rose_pine').setup({transparent=false})" "+qa" 2>&1
```

Expected for each: no output, exit 0. Any Lua error means the adapter or upstream plugin name is wrong — re-check the relevant adapter.

- [ ] **Step 5: Verify nvim still launches cleanly with the new modules present**

```bash
nvim --headless "+qa" 2>&1
```

Expected: no output, exit 0. (Adapter modules sitting in `nvim/lua/themes/` aren't required by anything yet, so they should be inert at startup.)

- [ ] **Step 6: Commit Task 2**

```bash
git add nvim/lua/themes/kanagawa.lua nvim/lua/themes/rose_pine.lua nvim/lua/themes/vscode.lua
git commit -m "$(cat <<'EOF'
nvim: add theme adapter modules for kanagawa, rose-pine, vscode

Each adapter exposes M.setup({ transparent = bool }) and translates the
boolean to whatever option name the underlying plugin uses (kanagawa and
vscode use 'transparent'; rose-pine inverts to 'disable_background').

No callers yet — the orchestrator that uses them lands in a later commit.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 3: Extract catppuccin's setup into a themes module

**Files:**
- Create: `nvim/lua/themes/catppuccin.lua`

After this task: `nvim/lua/themes/catppuccin.lua` exists and exposes `M.setup({ transparent })` containing all the highlight overrides currently in `nvim/lua/plugins/catppuccin.lua`'s `config`. The plugin spec at `nvim/lua/plugins/catppuccin.lua` is **not modified yet** — its inline `config` is still the active codepath, so the new themes module is loadable but unused. The cutover happens in Task 5.

- [ ] **Step 1: Create the new themes/catppuccin.lua file**

Create `nvim/lua/themes/catppuccin.lua` with exactly this content:

```lua
local M = {}

function M.setup(opts)
  opts = opts or {}
  local transparent = opts.transparent
  if transparent == nil then transparent = true end

  require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = transparent,
    integrations = {
      neotree = true,
      telescope = true,
      treesitter = true,
      gitsigns = true,
      mason = true,
      native_lsp = { enabled = true },
      cmp = true,
      bufferline = true,
      indent_blankline = { enabled = true },
    },
    custom_highlights = function(colors)
      local panel_bg = colors.mantle
      local out = {
        StatusLine = { bg = panel_bg, fg = colors.text },
        StatusLineNC = { bg = panel_bg, fg = colors.overlay0 },

        NormalFloat = { bg = panel_bg },
        FloatBorder = { bg = panel_bg, fg = colors.blue },
        FloatTitle = { bg = panel_bg, fg = colors.lavender },

        TelescopeNormal = { bg = panel_bg },
        TelescopeBorder = { bg = panel_bg, fg = colors.blue },
        TelescopeTitle = { bg = panel_bg, fg = colors.lavender },
        TelescopePromptNormal = { bg = colors.surface0 },
        TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
        TelescopePromptTitle = { bg = colors.surface0, fg = colors.lavender },
        TelescopePreviewNormal = { bg = panel_bg },
        TelescopePreviewBorder = { bg = panel_bg, fg = colors.blue },
        TelescopeResultsNormal = { bg = panel_bg },
        TelescopeResultsBorder = { bg = panel_bg, fg = colors.blue },
        TelescopeSelection = { bg = colors.surface0 },

        Pmenu = { bg = panel_bg, fg = colors.text },
        PmenuSel = { bg = colors.surface1, fg = colors.text },
        PmenuSbar = { bg = panel_bg },
        PmenuThumb = { bg = colors.overlay0 },

        WhichKeyFloat = { bg = panel_bg },
        WhichKeyBorder = { bg = panel_bg, fg = colors.blue },

        MasonNormal = { bg = panel_bg },
        MasonHeader = { bg = panel_bg, fg = colors.lavender },
        MasonHighlight = { fg = colors.blue },
        MasonHighlightBlock = { bg = colors.surface0, fg = colors.text },
        MasonHighlightBlockBold = { bg = colors.surface0, fg = colors.text, bold = true },
        MasonMuted = { fg = colors.overlay0 },
        MasonMutedBlock = { bg = colors.surface0, fg = colors.overlay1 },

        LspInfoBorder = { bg = panel_bg, fg = colors.blue },
        LspInfoTitle = { bg = panel_bg, fg = colors.lavender },
        LspInfoFiletype = { bg = panel_bg, fg = colors.yellow },
        LspInfoTip = { bg = panel_bg, fg = colors.overlay1 },
        LspInfoList = { bg = panel_bg, fg = colors.green },

        DiagnosticFloatingError = { bg = panel_bg, fg = colors.red },
        DiagnosticFloatingWarn = { bg = panel_bg, fg = colors.yellow },
        DiagnosticFloatingInfo = { bg = panel_bg, fg = colors.sky },
        DiagnosticFloatingHint = { bg = panel_bg, fg = colors.teal },
        DiagnosticFloatingOk = { bg = panel_bg, fg = colors.green },
      }
      if transparent then
        out.Normal = { bg = "NONE" }
        out.NormalNC = { bg = "NONE" }
        out.SignColumn = { bg = "NONE" }
        out.VertSplit = { bg = "NONE" }
        out.WinSeparator = { bg = "NONE" }
        out.TabLine = { bg = "NONE" }
        out.TabLineFill = { bg = "NONE" }
        out.EndOfBuffer = { bg = "NONE" }
        out.NeoTreeNormal = { bg = "NONE" }
        out.NeoTreeNormalNC = { bg = "NONE" }
        out.NeoTreeEndOfBuffer = { bg = "NONE" }
        out.BufferLineFill = { bg = "NONE" }
      end
      return out
    end,
  })

  local function apply_overrides()
    local C = require("catppuccin.palettes").get_palette("mocha")
    local set = vim.api.nvim_set_hl

    set(0, "DiagnosticUnderlineError", { undercurl = true, underline = true, sp = C.red })
    set(0, "DiagnosticUnderlineWarn",  { undercurl = true, underline = true, sp = C.yellow })
    set(0, "DiagnosticUnderlineInfo",  { undercurl = true, underline = true, sp = C.sky })
    set(0, "DiagnosticUnderlineHint",  { undercurl = true, underline = true, sp = C.teal })
    set(0, "DiagnosticUnderlineOk",    { undercurl = true, underline = true, sp = C.green })

    if transparent then
      local panel_bg = C.mantle
      local cmp_bg, cmp_sel_bg = "#0f1729", "#1e2a4a"
      set(0, "NormalFloat", { bg = panel_bg, blend = 0 })
      set(0, "FloatBorder", { bg = panel_bg, fg = C.blue, blend = 0 })
      set(0, "FloatTitle", { bg = panel_bg, fg = C.lavender, blend = 0 })
      set(0, "Pmenu", { bg = panel_bg, fg = C.text, blend = 0 })
      set(0, "PmenuSel", { bg = C.surface1, fg = C.text, blend = 0 })
      set(0, "CmpFloat", { bg = cmp_bg, fg = C.text, blend = 0 })
      set(0, "CmpFloatSel", { bg = cmp_sel_bg, fg = C.text, blend = 0 })
      set(0, "MasonNormal", { bg = panel_bg })
      set(0, "LspInfoBorder", { bg = panel_bg, fg = C.blue })
      set(0, "DiagnosticFloatingError", { bg = panel_bg, fg = C.red })
      set(0, "DiagnosticFloatingWarn", { bg = panel_bg, fg = C.yellow })
      set(0, "DiagnosticFloatingInfo", { bg = panel_bg, fg = C.sky })
      set(0, "DiagnosticFloatingHint", { bg = panel_bg, fg = C.teal })
      set(0, "DiagnosticFloatingOk", { bg = panel_bg, fg = C.green })
    end
  end

  apply_overrides()

  local group = vim.api.nvim_create_augroup("CatppuccinThemeOverrides", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    pattern = "catppuccin*",
    callback = apply_overrides,
  })
end

return M
```

Key differences from the current `nvim/lua/plugins/catppuccin.lua`:

| Change | Why |
|---|---|
| Wrapped in `M.setup(opts)` returning a module table | Lets the orchestrator re-call setup at runtime when transparency toggles. |
| `transparent_background = transparent` (parameter) | Previously hardcoded `true`; now driven by the `opts.transparent` argument. |
| `bg = "NONE"` overrides moved into `if transparent then` block | When transparency is off, catppuccin's native panel backgrounds show through cleanly instead of being forced to NONE. |
| `apply_overrides()` body wraps the float-bg lines in `if transparent then` | Same reasoning — when opaque, leave catppuccin's native float styling alone. The diagnostic-underline lines still apply unconditionally (they aren't background-related). |
| Autocmd registered inside an augroup with `clear = true` and `pattern = "catppuccin*"` | The pattern stops the autocmd from clobbering kanagawa/vscode/rose-pine. The augroup with `clear = true` makes re-running setup safe (toggling transparency calls setup again — without the augroup, autocmds would accumulate). |
| `vim.cmd.colorscheme("catppuccin-mocha")` removed | The orchestrator owns the colorscheme call. Calling it here would conflict. |

- [ ] **Step 2: Verify the new module is loadable and setup runs without errors**

```bash
nvim --headless "+lua require('themes.catppuccin').setup({transparent=true})" "+qa" 2>&1
nvim --headless "+lua require('themes.catppuccin').setup({transparent=false})" "+qa" 2>&1
```

Expected for each: no output, exit 0. (`themes/catppuccin.lua` triggers `require("catppuccin").setup(...)`, which is fine to call additively; the existing `plugins/catppuccin.lua` still calls it too at startup, so this just runs setup an extra time.)

- [ ] **Step 3: Verify nvim still launches and catppuccin is still the default**

```bash
nvim --headless "+lua print(vim.g.colors_name)" "+qa" 2>&1
```

Expected: `catppuccin-mocha`. (Nothing has changed about how catppuccin is invoked at startup yet — that switchover is Task 5.)

- [ ] **Step 4: Commit Task 3**

```bash
git add nvim/lua/themes/catppuccin.lua
git commit -m "$(cat <<'EOF'
nvim: extract catppuccin setup into themes/catppuccin.lua

Same setup body as plugins/catppuccin.lua, restructured to:
- accept a transparent parameter (defaulting true) instead of hardcoding it
- gate bg=NONE overrides and float-bg apply_overrides on transparency
- gate the ColorScheme autocmd by 'catppuccin*' pattern, inside an
  augroup with clear=true so re-setup doesn't accumulate autocmds

Not yet wired in — plugins/catppuccin.lua's inline config is still the
active codepath. Cutover happens in a later commit.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 4: Add the orchestrator module

**Files:**
- Create: `nvim/lua/themes/init.lua`

After this task: `require("themes")` is loadable; `require("themes").setup()` would work end-to-end (load persisted state, set up the active theme, register keymaps), but **nothing calls it yet** — that wiring lands in Task 5. So this task is purely additive and inert at startup.

- [ ] **Step 1: Create the orchestrator file**

Create `nvim/lua/themes/init.lua` with exactly this content:

```lua
local M = {}

local state = { theme = "catppuccin", transparent = true }

local registry = {
  catppuccin = {
    colorscheme = "catppuccin-mocha",
    setup = function(o) require("themes.catppuccin").setup(o) end,
  },
  kanagawa = {
    colorscheme = "kanagawa",
    setup = function(o) require("themes.kanagawa").setup(o) end,
  },
  vscode = {
    colorscheme = "vscode",
    setup = function(o) require("themes.vscode").setup(o) end,
  },
  ["rose-pine"] = {
    colorscheme = "rose-pine",
    setup = function(o) require("themes.rose_pine").setup(o) end,
  },
}

local function persist_path()
  return vim.fn.stdpath("data") .. "/theme.json"
end

local function load_persisted()
  local ok, data = pcall(function()
    local f = io.open(persist_path(), "r")
    if not f then return nil end
    local content = f:read("*a")
    f:close()
    return vim.json.decode(content)
  end)
  if ok and type(data) == "table" then
    if registry[data.theme] then state.theme = data.theme end
    if type(data.transparent) == "boolean" then state.transparent = data.transparent end
  end
end

local function save()
  pcall(function()
    local f = io.open(persist_path(), "w")
    if not f then return end
    f:write(vim.json.encode(state))
    f:close()
  end)
end

function M.set(name)
  local entry = registry[name]
  if not entry then
    vim.notify("Unknown theme: " .. tostring(name), vim.log.levels.ERROR)
    return
  end
  entry.setup({ transparent = state.transparent })
  vim.cmd.colorscheme(entry.colorscheme)
  state.theme = name
  save()
  vim.notify("Theme: " .. name)
end

function M.toggle_transparency()
  state.transparent = not state.transparent
  local entry = registry[state.theme]
  entry.setup({ transparent = state.transparent })
  vim.cmd.colorscheme(entry.colorscheme)
  save()
  vim.notify("Transparency: " .. (state.transparent and "on" or "off"))
end

function M.setup()
  load_persisted()
  local entry = registry[state.theme]
  entry.setup({ transparent = state.transparent })
  vim.cmd.colorscheme(entry.colorscheme)

  local map = vim.keymap.set
  map("n", "<leader>uc", function() M.set("catppuccin") end, { desc = "Theme: Catppuccin" })
  map("n", "<leader>uk", function() M.set("kanagawa")   end, { desc = "Theme: Kanagawa" })
  map("n", "<leader>uv", function() M.set("vscode")     end, { desc = "Theme: VSCode" })
  map("n", "<leader>ur", function() M.set("rose-pine")  end, { desc = "Theme: Rose Pine" })
  map("n", "<leader>ub", function() M.toggle_transparency() end, { desc = "Toggle background transparency" })
end

return M
```

Notes for context (do not include in the file):
- The `setup` field in each registry entry stores a closure, **not** the result of calling the adapter. The `require("themes.<name>")` inside the closure runs only when the closure is invoked — module load of `themes/init.lua` is therefore side-effect-free.
- `state.transparent = true` and `state.theme = "catppuccin"` as defaults preserve today's behavior on first run (no persistence file).
- `load_persisted` validates the theme name against the registry; an unknown name (e.g. user removed `kanagawa.lua`) silently falls back to the default. Same for non-boolean `transparent`.
- `save()` is `pcall`-wrapped; a failed write doesn't break the editor.
- Each keymap wraps its action in a closure so a load-order issue surfaces as a clear error rather than a `nil` argument.

- [ ] **Step 2: Verify the module loads without side effects**

```bash
nvim --headless "+lua require('themes')" "+qa" 2>&1
```

Expected: no output, exit 0. (Just requiring the module should not call `M.setup()` or any of the per-theme setup functions.)

- [ ] **Step 3: Verify the registry contains the expected four themes**

```bash
nvim --headless "+lua local r = require('themes'); print(type(r.set), type(r.toggle_transparency), type(r.setup))" "+qa" 2>&1
```

Expected output: `function	function	function` (three function types, tab-separated). Confirms the public API is in place.

- [ ] **Step 4: Verify nvim still launches with catppuccin as default**

```bash
nvim --headless "+lua print(vim.g.colors_name)" "+qa" 2>&1
```

Expected: `catppuccin-mocha`. (Nothing wires `themes.setup()` yet, so the existing `plugins/catppuccin.lua` config remains the active codepath.)

- [ ] **Step 5: Commit Task 4**

```bash
git add nvim/lua/themes/init.lua
git commit -m "$(cat <<'EOF'
nvim: add theme switcher orchestrator (themes/init.lua)

Holds the registry, in-memory state, persistence (read/write
~/.local/share/nvim/theme.json), set/toggle_transparency, and the
M.setup() entry point that registers the five <leader>u… keymaps.

Not yet called from init.lua; cutover happens in the next commit.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 5: Cut over — slim the catppuccin spec, wire the orchestrator, register which-key entries

This is the atomic switchover. After this commit:
- `plugins/catppuccin.lua` no longer calls `setup()` directly — the orchestrator does it.
- `init.lua` calls `require("themes").setup()` after `lazy.setup`.
- which-key shows the new `<leader>u` group on its popup.

The three file edits **must land in one commit**, because any subset would leave the editor in a broken state (e.g. plugins/catppuccin.lua slim with no orchestrator wired = no theme applied at all).

**Files:**
- Modify: `nvim/lua/plugins/catppuccin.lua`
- Modify: `nvim/init.lua`
- Modify: `nvim/lua/plugins/which-key.lua`

- [ ] **Step 1: Confirm baseline content of plugins/catppuccin.lua**

```bash
sed -n '1,7p' /home/Jason/nvim/nvim/lua/plugins/catppuccin.lua
```

Expected output:

```
return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
```

(If lines have drifted, adjust Step 2 accordingly.)

- [ ] **Step 2: Replace plugins/catppuccin.lua with the slim install-only spec**

Use `Write` (or your editor's overwrite operation) to set `nvim/lua/plugins/catppuccin.lua` to **exactly** this content (entire file, replacing the current 123 lines):

```lua
return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,
}
```

After this step: lazy.nvim still installs catppuccin, still loads it eagerly, but no longer auto-configures it. The orchestrator will configure it from `init.lua` (next steps).

- [ ] **Step 3: Confirm baseline content of init.lua**

```bash
cat /home/Jason/nvim/nvim/init.lua
```

Expected:

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("vim-options")
require("lazy").setup("plugins")
require("highlights")
```

(If lines have drifted, adjust Step 4 accordingly.)

- [ ] **Step 4: Add `require("themes").setup()` to init.lua**

Edit `nvim/init.lua`.

`old_string`:

```
require("vim-options")
require("lazy").setup("plugins")
require("highlights")
```

`new_string`:

```
require("vim-options")
require("lazy").setup("plugins")
require("themes").setup()
require("highlights")
```

The order matters: `themes.setup()` must run **after** `lazy.setup` (so the catppuccin plugin is loaded and `require("catppuccin")` works) and **before** `require("highlights")` (so the LineNr/CursorLineNr overrides land on top of whatever theme just got applied — same relative ordering as before this change).

- [ ] **Step 5: Confirm baseline content of which-key.lua's spec table**

```bash
sed -n '28,33p' /home/Jason/nvim/nvim/lua/plugins/which-key.lua
```

Expected:

```
      { "<leader>q", desc = "Quit" },
      { "<leader>l", desc = "Run last test" },
      { "<leader>a", desc = "Run all tests" },
      { "<leader>T", desc = "Run file tests" },
    },
  },
```

(If lines have drifted, adjust Step 6 accordingly.)

- [ ] **Step 6: Append the six new which-key entries**

Edit `nvim/lua/plugins/which-key.lua`.

`old_string`:

```
      { "<leader>T", desc = "Run file tests" },
    },
```

`new_string`:

```
      { "<leader>T", desc = "Run file tests" },
      { "<leader>u",  group = "ui / theme" },
      { "<leader>uc", desc = "Catppuccin" },
      { "<leader>uk", desc = "Kanagawa" },
      { "<leader>uv", desc = "VSCode" },
      { "<leader>ur", desc = "Rose Pine" },
      { "<leader>ub", desc = "Toggle transparency" },
    },
```

**Important:** the trailing `    },` on the last line of `new_string` is the closing brace of the surrounding `spec` table — it must be preserved or the Lua file will fail to parse.

- [ ] **Step 7: Verify nvim launches cleanly and catppuccin is still the default**

```bash
nvim --headless "+lua print(vim.g.colors_name)" "+qa" 2>&1
```

Expected: `catppuccin-mocha`. (No persistence file exists yet, so the orchestrator falls back to the default theme — which matches today's behavior. If this prints anything else or errors, something in the wiring is wrong.)

- [ ] **Step 8: Verify the catppuccin custom highlights are still applied (TelescopeNormal as a proxy)**

```bash
nvim --headless "+lua print(vim.inspect(vim.api.nvim_get_hl(0, { name = 'TelescopeNormal' })))" "+qa" 2>&1
```

Expected: a non-empty Lua table containing a `bg` field with a numeric value (catppuccin's mantle color, ~`{ bg = 1576472 }` or similar). An empty table `{}` means the orchestrator didn't successfully run catppuccin's setup — re-check Steps 2 and 4.

- [ ] **Step 9: Verify the orchestrator's keymaps are registered**

```bash
nvim --headless "+lua local found=false; for _,m in ipairs(vim.api.nvim_get_keymap('n')) do if m.lhs==' uc' then found=true end end; print(found and 'mapped' or 'missing')" "+qa" 2>&1
```

Expected: `mapped`. (Note: `<leader>` resolves to space, so the lhs is the literal string `' uc'`. We match against `nvim_get_keymap` rather than `maparg.rhs` because `vim.keymap.set` with a Lua function leaves `rhs` empty and stores the action in `callback`. If `missing` prints, the keymap registration in `themes.setup()` did not run — re-check Step 4 of this task.)

- [ ] **Step 10: Verify the catppuccin autocmd is now gated by pattern (not catching all colorschemes)**

```bash
nvim --headless "+lua local autos = vim.api.nvim_get_autocmds({event='ColorScheme', group='CatppuccinThemeOverrides'}); print(#autos > 0 and autos[1].pattern or 'missing')" "+qa" 2>&1
```

Expected: `catppuccin*`. (If `missing`, the augroup wasn't created — re-check `themes/catppuccin.lua` from Task 3.)

- [ ] **Step 11: Commit Task 5**

```bash
git add nvim/lua/plugins/catppuccin.lua nvim/init.lua nvim/lua/plugins/which-key.lua
git commit -m "$(cat <<'EOF'
nvim: wire theme switcher with <leader>u… keymaps

Slims plugins/catppuccin.lua to install-only (config moved to
themes/catppuccin.lua in a previous commit), calls
require('themes').setup() from init.lua to apply persisted theme +
transparency on startup, and registers the six new <leader>u entries
in which-key's spec.

Adds keymaps:
  <leader>uc  Catppuccin
  <leader>uk  Kanagawa
  <leader>uv  VSCode
  <leader>ur  Rose Pine
  <leader>ub  Toggle background transparency

Selected theme and transparency persist across restarts via
~/.local/share/nvim/theme.json.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 6: End-to-end manual verification

**Files:** none modified.

This task runs the spec's verification checklist in an interactive nvim session. There is no automated test suite per `CLAUDE.md`. **Do not commit anything in this task** — it is acceptance testing only. If any step fails, diagnose, fix the offending earlier task with a follow-up commit, and re-run the failing step.

- [ ] **Step 1: Clear persistence and confirm fresh-install defaults**

From the shell:

```bash
rm -f ~/.local/share/nvim/theme.json
nvim /home/Jason/nvim/nvim/init.lua
```

Expected on launch: catppuccin-mocha colors, transparent background (terminal background visible behind buffer text), Telescope/Mason/which-key panels render with the dark mantle background you had before this change. **Visually identical to before the feature.**

- [ ] **Step 2: Switch to each new theme**

In the running nvim session, press in turn:
- `<Space>uk` → expect a notification "Theme: kanagawa"; buffer text and statusline visibly switch to kanagawa's palette (warm muted sumi-e tones).
- `<Space>uv` → notification "Theme: vscode"; switches to vscode's dark+ palette (blues and oranges).
- `<Space>ur` → notification "Theme: rose-pine"; switches to rose-pine's muted plum/rose palette.
- `<Space>uc` → notification "Theme: catppuccin"; back to catppuccin-mocha with all the customized panel styling.

After each switch, run `:messages` and confirm no Lua errors. Also confirm transparency is preserved (you should still see the terminal background through the buffer area on each theme).

- [ ] **Step 3: Toggle transparency on each theme**

On any theme, press `<Space>ub`. Expected: notification "Transparency: off"; buffer background fills with the theme's native opaque background color (terminal bg no longer visible through it).

Press `<Space>ub` again. Expected: notification "Transparency: on"; buffer background returns to transparent.

Repeat for at least two themes (e.g. catppuccin and kanagawa) to confirm the toggle works uniformly.

- [ ] **Step 4: Verify catppuccin's autocmd does not bleed into other themes**

Switch to kanagawa with `<Space>uk`. Inside nvim, run:

```vim
:colorscheme kanagawa
```

(Re-applying kanagawa explicitly to fire a fresh `ColorScheme` event.) Expected: no visual change. In particular, **Telescope panels should still render with kanagawa's natural palette**, not catppuccin's mantle background. If you see catppuccin colors on Telescope after this, the `pattern = "catppuccin*"` gate from Task 3 is not in place.

Open Telescope to make this visible:

```vim
:Telescope find_files
```

Expected: panel backgrounds match kanagawa, not catppuccin. Press `<Esc>` to close.

- [ ] **Step 5: Verify persistence — theme**

Switch to kanagawa (`<Space>uk`), then quit nvim (`:qa`).

Inspect the persistence file:

```bash
cat ~/.local/share/nvim/theme.json
```

Expected: `{"theme":"kanagawa","transparent":true}` (or with `false` if you toggled).

Relaunch:

```bash
nvim
```

Expected: nvim opens directly into kanagawa, no flash of catppuccin first.

- [ ] **Step 6: Verify persistence — transparency**

In the kanagawa session from Step 5, press `<Space>ub` (toggle off), then quit (`:qa`).

```bash
cat ~/.local/share/nvim/theme.json
```

Expected: `{"theme":"kanagawa","transparent":false}`.

Relaunch nvim. Expected: kanagawa loads with its opaque background.

Press `<Space>ub` to flip back to transparent, then `<Space>uc` to return to catppuccin for the remaining checks.

- [ ] **Step 7: Verify persistence fallback — missing file**

Quit nvim, then:

```bash
rm ~/.local/share/nvim/theme.json
nvim
```

Expected: catppuccin-mocha loads transparent (fresh-install defaults). No error messages in `:messages`.

- [ ] **Step 8: Verify persistence fallback — corrupted file**

Quit nvim, then:

```bash
echo "this is not json" > ~/.local/share/nvim/theme.json
nvim
```

Expected: catppuccin-mocha loads transparent (defaults). No error. Run `:messages` and confirm nothing complains about JSON parsing — the `pcall` wrap should swallow it silently.

- [ ] **Step 9: Verify which-key shows the new group**

Inside nvim, press `<Space>` and wait ~300 ms (the configured which-key delay). Expected: the popup contains a `u → ui / theme` row.

Press `u`. Expected: the popup expands to show all five entries:
- `c → Catppuccin`
- `k → Kanagawa`
- `v → VSCode`
- `r → Rose Pine`
- `b → Toggle transparency`

Press `<Esc>` to dismiss.

- [ ] **Step 10: Verify catppuccin still feels right (regression check)**

While on catppuccin (`<Space>uc` to be sure), open each of the following and confirm the panels look exactly as they did before this work:

```vim
:Telescope find_files
```
Confirm the Telescope panel uses the dark mantle background and has the lavender/blue title styling. Press `<Esc>`.

```vim
:Mason
```
Confirm Mason's window uses the panel background. Press `q` to close.

Open any LSP-aware buffer (e.g. a `.lua` file) and trigger a hover with `K`. Confirm the floating window has the dark mantle background and blue border.

Trigger completion (insert mode in a Lua file, type `vim.`). Confirm the completion popup uses the customized dark blue cmp background.

If any of these look "stock catppuccin" (i.e. without the customized panel styling), the catppuccin custom_highlights or apply_overrides isn't running — re-check Task 3 and Task 5 Steps 2 + 8.

- [ ] **Step 11: Final commit log check**

From the shell:

```bash
git log --oneline -6
```

Expected (most recent first):

```
<sha> nvim: wire theme switcher with <leader>u… keymaps
<sha> nvim: add theme switcher orchestrator (themes/init.lua)
<sha> nvim: extract catppuccin setup into themes/catppuccin.lua
<sha> nvim: add theme adapter modules for kanagawa, rose-pine, vscode
<sha> nvim: install kanagawa, rose-pine, vscode colorscheme plugins
525db5c docs: spec for theme switcher (<leader>u…)
```

If any of Steps 1–10 failed and you haven't fixed them, stop here. Otherwise, the feature is complete.

---

## Spec coverage check (for the implementer)

| Spec section | Implemented in |
|---|---|
| Architecture: two-layer split (plugin specs vs theme modules) | Tasks 1, 2, 3, 4, 5 |
| Files touched: 3 new plugin specs | Task 1 |
| Files touched: 3 new adapter modules | Task 2 |
| Files touched: themes/catppuccin.lua extraction | Task 3 |
| Files touched: themes/init.lua orchestrator | Task 4 |
| Files touched: slim plugins/catppuccin.lua | Task 5 Step 2 |
| Files touched: init.lua wires `require("themes").setup()` | Task 5 Step 4 |
| Files touched: which-key.lua spec entries | Task 5 Step 6 |
| Per-theme adapter contract (`M.setup({ transparent })`) | Task 2 |
| rose-pine option polarity inversion | Task 2 Step 3 |
| Catppuccin autocmd gated with `pattern = "catppuccin*"` | Task 3 Step 1 (verified Task 5 Step 10) |
| Catppuccin `bg = "NONE"` overrides gated on transparency | Task 3 Step 1 |
| Persistence file at `stdpath("data") .. "/theme.json"` | Task 4 Step 1 |
| Persistence edge cases (missing/malformed/unknown theme/non-bool transparent) | Task 4 Step 1 (verified Task 6 Steps 7, 8) |
| `M.set(name)` flow (lookup → setup → colorscheme → save → notify) | Task 4 Step 1 |
| `M.toggle_transparency()` flow | Task 4 Step 1 |
| Orchestrator startup order (after lazy.setup, before highlights) | Task 5 Step 4 |
| Five `<leader>u…` keymaps | Task 4 Step 1 + Task 5 Step 6 (which-key labels) |
| Behavior summary (fresh, switch, toggle, restart, popup, delete-file fallback) | Task 6 Steps 1–9 |
| Out-of-scope items (catppuccin flavours, custom highlights for other themes, picker, lazy-loading inactive themes, random/cycle) | Intentionally not implemented — do not add. |
