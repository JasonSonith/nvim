# Graph Report - nvim  (2026-09-26)

## Corpus Check
- 15 files · ~19,016 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 175 nodes · 204 edges · 36 communities (11 shown, 25 thin omitted)
- Extraction: 92% EXTRACTED · 8% INFERRED · 0% AMBIGUOUS · INFERRED: 17 edges (avg confidence: 0.87)
- Token cost: 116,538 input · 0 output

## Community Hubs (Navigation)
- LSP, Telescope & Nav
- Indent Guides & Find-Files Specs
- Theme Switcher Design
- Repo Conventions & Tmux
- Plugin Architecture & Init
- Install Script
- Treesitter & Reload Workflow
- Theme Orchestrator Code
- Completion & Autopairs
- none-ls Formatting
- XLSX Viewer
- Autotag

## God Nodes (most connected - your core abstractions)
1. `Highlights: Editor Feature Set` - 18 edges
2. `Theme Switcher Design Spec` - 11 edges
3. `Theme Switcher Implementation Plan` - 9 edges
4. `Indent Guides Toggle Design Spec` - 9 edges
5. `Cross-File Invariants (keep paired files in sync)` - 8 edges
6. `tmux/tmux.conf` - 7 edges
7. `Indent Guides Toggle Implementation Plan` - 6 edges
8. `install.sh script` - 6 edges
9. `Plugin Architecture: lazy.nvim Auto-Discovery of nvim/lua/plugins/` - 6 edges
10. `Tmux Plugin Management via TPM` - 6 edges

## Surprising Connections (you probably didn't know these)
- `Plugin Architecture: lazy.nvim Auto-Discovery of nvim/lua/plugins/` --semantically_similar_to--> `lazy.nvim (plugin manager)`  [INFERRED] [semantically similar]
  CLAUDE.md → README.md
- `Quick Start (new machine) install steps` --semantically_similar_to--> `install.sh Gotchas: apt/npm conflict avoidance, numeric Neovim version compare, timestamped backups`  [INFERRED] [semantically similar]
  README.md → CLAUDE.md
- `mason-lspconfig` --semantically_similar_to--> `mason`  [INFERRED] [semantically similar]
  CLAUDE.md → README.md
- `Tmux Quickstart Keybindings (prefix Ctrl-a)` --conceptually_related_to--> `tmux/tmux.conf`  [INFERRED]
  README.md → CLAUDE.md
- `Move find_files Binding from <C-p> to <leader>ff` --conceptually_related_to--> `which-key`  [INFERRED]
  docs/superpowers/specs/2026-05-06-find-files-keymap-design.md → README.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Multi-Theme Switching System** — docs_superpowers_plans_2026_05_07_theme_switcher_new_colorscheme_plugins, docs_superpowers_plans_2026_05_07_theme_switcher_orchestrator, docs_superpowers_specs_2026_05_07_theme_switcher_design_orchestrator_api [INFERRED 0.75]
- **Superpowers Plan/Spec Documentation Pattern** — docs_superpowers_plans_2026_05_06_indent_guides_toggle_doc, docs_superpowers_specs_2026_05_06_indent_guides_toggle_design_doc, docs_superpowers_plans_2026_05_07_theme_switcher_doc, docs_superpowers_specs_2026_05_07_theme_switcher_design_doc [INFERRED 0.85]
- **Tmux ↔ Nvim Pane Navigation Kept in Sync Across tmux.conf and nvim-tmux-navigation.lua** — tmux_tmux_conf_file, nvim_lua_plugins_nvim_tmux_navigation, claude_cross_file_invariants [EXTRACTED 1.00]
- **Adding a Language Requires Editing Both lsp-config.lua and treesitter.lua ensure_installed Lists** — nvim_lua_plugins_lsp_config, nvim_lua_plugins_treesitter, claude_cross_file_invariants [EXTRACTED 1.00]
- **Committed Knowledge Graph Output Bundle** — graphify_out_dir, graphify_out_graph_json_file, graphify_out_graph_html_file, graphify_out_graph_report_file [EXTRACTED 1.00]

## Communities (36 total, 25 thin omitted)

### Community 0 - "LSP, Telescope & Nav"
Cohesion: 0.08
Nodes (21): mason-lspconfig, cmp_nvim_lsp, mason, mason_registry, bufferline, catppuccin-mocha theme, fugitive, gitsigns (+13 more)

### Community 1 - "Indent Guides & Find-Files Specs"
Cohesion: 0.12
Nodes (20): catppuccin ibl Integration Line, Indent Guides Toggle Implementation Plan, indent-blankline.nvim Plugin Spec (ibl v3), <leader>i Indent Guides Toggle Keymap, Manual E2E Verification Checklist (Task 4), which-key Entry for <leader>i, Find-Files Keymap Design Spec, Move find_files Binding from <C-p> to <leader>ff (+12 more)

### Community 2 - "Theme Switcher Design"
Cohesion: 0.13
Nodes (21): Catppuccin Setup Extraction into themes/catppuccin.lua, Atomic Cutover (Task 5), Theme Switcher Implementation Plan, Three New Colorscheme Plugin Installs (kanagawa, rose-pine, vscode), Theme Orchestrator (themes/init.lua), Theme + Transparency Persistence (theme.json), Theme Adapter Modules (kanagawa, rose_pine, vscode), Two-Layer Architecture (plugin specs vs theme modules) (+13 more)

### Community 3 - "Repo Conventions & Tmux"
Cohesion: 0.15
Nodes (14): Catppuccin Highlights Applied Twice: ColorScheme Autocmd Is Load-Bearing (some plugins re-apply highlights after setup() and would clobber the first pass), Cross-File Invariants (keep paired files in sync), Knowledge Graph (graphify) Update Workflow: run /graphify . --update at end of session, Repo Purpose: Dotfiles Are the Live Config (no build step, no tests), tmux-continuum, Tmux Plugin Management via TPM, tmux-resurrect, TPM (Tmux Plugin Manager) (+6 more)

### Community 4 - "Plugin Architecture & Init"
Cohesion: 0.18
Nodes (9): Plugin Architecture: lazy.nvim Auto-Discovery of nvim/lua/plugins/, lazy, nvim/lazy-lock.json, nvim/lua/plugins/ (directory), nvim/lua/plugins.lua (intentionally empty, shadowed), lazy.nvim (plugin manager), Updating Workflow (git pull + Lazy sync + TSUpdateSync), themes (+1 more)

### Community 5 - "Install Script"
Cohesion: 0.36
Nodes (9): install.sh Gotchas: apt/npm conflict avoidance, numeric Neovim version compare, timestamped backups, ext_usr_lib_os_release, backup_then_link(), color(), info(), is_apt_family(), install.sh script, warn() (+1 more)

### Community 6 - "Treesitter & Reload Workflow"
Cohesion: 0.27
Nodes (9): Reload-After-Editing Workflow Table, Treesitter Python Parser Pinned to master + Custom Query Overrides (upstream indent query doesn't compile against master parser, breaking indentation), nvim/queries/ (directory, treesitter query overrides), nvim/queries/python/highlights.scm, nvim/queries/python/indents.scm, nvim_treesitter_configs, nvim_treesitter_parsers, nvim_treesitter_query_predicates (+1 more)

### Community 7 - "Theme Orchestrator Code"
Cohesion: 0.42
Nodes (6): load_persisted(), M.set(), M.setup(), M.toggle_transparency(), persist_path(), save()

### Community 8 - "Completion & Autopairs"
Cohesion: 0.29
Nodes (5): cmp, luasnip, luasnip_loaders_from_vscode, nvim_autopairs, nvim_autopairs_completion_cmp

### Community 9 - "none-ls Formatting"
Cohesion: 0.40
Nodes (4): Formatting via none-ls (stylua + prettier), bound to <leader>gf, prettier, stylua, null_ls

### Community 10 - "XLSX Viewer"
Cohesion: 0.50
Nodes (3): csvview, convert(), load_xlsx()

## Knowledge Gaps
- **26 isolated node(s):** `Risks (transparency toggle glitch, rose-pine polarity confusion, plugin rename, reversibility)`, `<leader>i Indent Guides Toggle Keymap`, `Risks (first-press latency, highlight clash, reversibility)`, `Out of Scope (alpha dashboard buttons, search-within-file, neo-tree keymaps, doc updates)`, `Risks (muscle memory transition, one-line revert)` (+21 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 81 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **25 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Highlights: Editor Feature Set` connect `LSP, Telescope & Nav` to `Indent Guides & Find-Files Specs`, `Plugin Architecture & Init`, `Treesitter & Reload Workflow`?**
  _High betweenness centrality (0.231) - this node is a cross-community bridge._
- **Why does `which-key` connect `Indent Guides & Find-Files Specs` to `LSP, Telescope & Nav`?**
  _High betweenness centrality (0.223) - this node is a cross-community bridge._
- **What connects `Risks (transparency toggle glitch, rose-pine polarity confusion, plugin rename, reversibility)`, `<leader>i Indent Guides Toggle Keymap`, `Risks (first-press latency, highlight clash, reversibility)` to the rest of the system?**
  _26 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `LSP, Telescope & Nav` be split into smaller, more focused modules?**
  _Cohesion score 0.08333333333333333 - nodes in this community are weakly interconnected._
- **Should `Indent Guides & Find-Files Specs` be split into smaller, more focused modules?**
  _Cohesion score 0.11904761904761904 - nodes in this community are weakly interconnected._
- **Should `Theme Switcher Design` be split into smaller, more focused modules?**
  _Cohesion score 0.13333333333333333 - nodes in this community are weakly interconnected._