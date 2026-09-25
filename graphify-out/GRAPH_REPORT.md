# Graph Report - nvim  (2026-09-25)

## Corpus Check
- Corpus is ~18,736 words - fits in a single context window. You may not need a graph.

## Summary
- 159 nodes · 161 edges · 39 communities (11 shown, 28 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 16 edges (avg confidence: 0.84)
- Token cost: 168,223 input · 0 output

## Community Hubs (Navigation)
- Repo Conventions & Tmux
- Theme Switcher Design
- Indent Guides Toggle
- Theme Orchestrator Code
- LSP & Telescope Config
- Install Script
- Core Nvim Init
- Find-Files Keymap Design
- Completion & Autopairs
- XLSX Viewer
- Treesitter Config
- none-ls Formatting
- Autotag

## God Nodes (most connected - your core abstractions)
1. `Theme Switcher Design Spec` - 11 edges
2. `Indent Guides Toggle Design Spec` - 9 edges
3. `Theme Switcher Implementation Plan` - 9 edges
4. `install.sh script` - 6 edges
5. `Indent Guides Toggle Implementation Plan` - 6 edges
6. `save()` - 4 edges
7. `M.setup()` - 4 edges
8. `TPM (Tmux Plugin Manager)` - 4 edges
9. `Catppuccin Highlight Overrides Invariant` - 4 edges
10. `Leader Keymaps Invariant (which-key spec)` - 4 edges

## Surprising Connections (you probably didn't know these)
- `Five <leader>u... Keymaps` --conceptually_related_to--> `Leader Keymaps Invariant (which-key spec)`  [INFERRED]
  docs/superpowers/specs/2026-05-07-theme-switcher-design.md → AGENTS.md
- `lazy.nvim (Plugin Manager)` --conceptually_related_to--> `lazy.nvim Auto-Discovery Plugin Architecture`  [INFERRED]
  README.md → AGENTS.md
- `Tmux Quickstart Keybindings` --conceptually_related_to--> `TPM (Tmux Plugin Manager)`  [INFERRED]
  README.md → AGENTS.md
- `alexghergh/nvim-tmux-navigation` --conceptually_related_to--> `Tmux <-> Nvim Pane Navigation Invariant`  [INFERRED]
  README.md → AGENTS.md
- `Catppuccin Setup Extraction into themes/catppuccin.lua` --conceptually_related_to--> `Catppuccin Highlight Overrides Invariant`  [INFERRED]
  docs/superpowers/plans/2026-05-07-theme-switcher.md → AGENTS.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Multi-Theme Switching System** — docs_superpowers_plans_2026_05_07_theme_switcher_new_colorscheme_plugins, docs_superpowers_plans_2026_05_07_theme_switcher_orchestrator, docs_superpowers_specs_2026_05_07_theme_switcher_design_orchestrator_api, readme_catppuccin_theme [INFERRED 0.75]
- **which-key.lua Spec Table Editing Convention** — agents_leader_keymaps_invariant, docs_superpowers_plans_2026_05_06_indent_guides_toggle_which_key_entry, docs_superpowers_plans_2026_05_07_theme_switcher_cutover_task5, docs_superpowers_specs_2026_05_06_find_files_keymap_design_keymap_change [INFERRED 0.75]
- **Superpowers Plan/Spec Documentation Pattern** — docs_superpowers_plans_2026_05_06_indent_guides_toggle_doc, docs_superpowers_specs_2026_05_06_indent_guides_toggle_design_doc, docs_superpowers_plans_2026_05_07_theme_switcher_doc, docs_superpowers_specs_2026_05_07_theme_switcher_design_doc [INFERRED 0.85]

## Communities (39 total, 28 thin omitted)

### Community 0 - "Repo Conventions & Tmux"
Cohesion: 0.07
Nodes (29): ensure_installed Lists Invariant, none-ls Formatting (stylua + prettier), install.sh Gotchas, lazy-lock.json Version Pinning, lazy.nvim Auto-Discovery Plugin Architecture, Reload-After-Editing Workflow, Repo Purpose: Nvim+Tmux Dotfiles, tmux-continuum (+21 more)

### Community 1 - "Theme Switcher Design"
Cohesion: 0.13
Nodes (23): Catppuccin Highlight Overrides Invariant, Catppuccin Setup Extraction into themes/catppuccin.lua, Atomic Cutover (Task 5), Theme Switcher Implementation Plan, Three New Colorscheme Plugin Installs (kanagawa, rose-pine, vscode), Theme Orchestrator (themes/init.lua), Theme + Transparency Persistence (theme.json), Theme Adapter Modules (kanagawa, rose_pine, vscode) (+15 more)

### Community 2 - "Indent Guides Toggle"
Cohesion: 0.20
Nodes (14): catppuccin ibl Integration Line, Indent Guides Toggle Implementation Plan, indent-blankline.nvim Plugin Spec (ibl v3), <leader>i Indent Guides Toggle Keymap, Manual E2E Verification Checklist (Task 4), which-key Entry for <leader>i, Toggle Behavior Summary (off by default, global, resets on restart), catppuccin indent_blankline Integration (+6 more)

### Community 3 - "Theme Orchestrator Code"
Cohesion: 0.42
Nodes (6): load_persisted(), M.set(), M.setup(), M.toggle_transparency(), persist_path(), save()

### Community 4 - "LSP & Telescope Config"
Cohesion: 0.25
Nodes (5): cmp_nvim_lsp, mason, mason_registry, telescope_builtin, telescope_themes

### Community 5 - "Install Script"
Cohesion: 0.46
Nodes (7): ext_usr_lib_os_release, backup_then_link(), color(), info(), is_apt_family(), install.sh script, warn()

### Community 6 - "Core Nvim Init"
Cohesion: 0.25
Nodes (3): lazy, themes, vim_ui_clipboard_osc52

### Community 7 - "Find-Files Keymap Design"
Cohesion: 0.33
Nodes (7): Leader Keymaps Invariant (which-key spec), Find-Files Keymap Design Spec, Move find_files Binding from <C-p> to <leader>ff, Out of Scope (alpha dashboard buttons, search-within-file, neo-tree keymaps, doc updates), Risks (muscle memory transition, one-line revert), Verification Steps (syntax check, which-key popup, keypress checks), which-key (leader keymap popup)

### Community 8 - "Completion & Autopairs"
Cohesion: 0.29
Nodes (5): cmp, luasnip, luasnip_loaders_from_vscode, nvim_autopairs, nvim_autopairs_completion_cmp

### Community 9 - "XLSX Viewer"
Cohesion: 0.50
Nodes (3): csvview, convert(), load_xlsx()

### Community 10 - "Treesitter Config"
Cohesion: 0.50
Nodes (3): nvim_treesitter_configs, nvim_treesitter_parsers, nvim_treesitter_query_predicates

## Knowledge Gaps
- **23 isolated node(s):** `lazy-lock.json Version Pinning`, `tmux-resurrect`, `tmux-continuum`, `Reload-After-Editing Workflow`, `none-ls Formatting (stylua + prettier)` (+18 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 83 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **28 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Move find_files Binding from <C-p> to <leader>ff` connect `Find-Files Keymap Design` to `Indent Guides Toggle`?**
  _High betweenness centrality (0.067) - this node is a cross-community bridge._
- **Why does `Indent Guides Toggle Design Spec` connect `Indent Guides Toggle` to `Theme Switcher Design`?**
  _High betweenness centrality (0.056) - this node is a cross-community bridge._
- **Why does `Leader Keymaps Invariant (which-key spec)` connect `Find-Files Keymap Design` to `Repo Conventions & Tmux`, `Theme Switcher Design`?**
  _High betweenness centrality (0.049) - this node is a cross-community bridge._
- **What connects `lazy-lock.json Version Pinning`, `tmux-resurrect`, `tmux-continuum` to the rest of the system?**
  _23 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Repo Conventions & Tmux` be split into smaller, more focused modules?**
  _Cohesion score 0.07056451612903226 - nodes in this community are weakly interconnected._
- **Should `Theme Switcher Design` be split into smaller, more focused modules?**
  _Cohesion score 0.12648221343873517 - nodes in this community are weakly interconnected._