# Graph Report - nvim  (2026-10-06)

## Corpus Check
- 11 files · ~19,891 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 196 nodes · 245 edges · 43 communities (13 shown, 30 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 24 edges (avg confidence: 0.86)
- Token cost: 165,426 input · 0 output

## Community Hubs (Navigation)
- Repo Conventions & Tmux
- Theme Switcher Design
- Editor Features & Motions
- Plugin Architecture & Init
- Indent Guides Toggle Spec
- Install Script & macOS
- LSP, Telescope & Nav
- Treesitter & Queries
- Theme Orchestrator Code
- Completion & Autopairs
- Find-Files Keymap Spec
- conform Formatting
- XLSX Viewer
- Autotag

## God Nodes (most connected - your core abstractions)
1. `Highlights: Editor Feature Set` - 23 edges
2. `Cross-File Invariants (keep paired files in sync)` - 12 edges
3. `Theme Switcher Design Spec` - 11 edges
4. `Indent Guides Toggle Design Spec` - 9 edges
5. `Theme Switcher Implementation Plan` - 9 edges
6. `tmux/tmux.conf` - 8 edges
7. `Indent Guides Toggle Implementation Plan` - 6 edges
8. `install.sh script` - 6 edges
9. `macOS post-install checklist` - 6 edges
10. `Knowledge Graph (graphify) Update Workflow: run /graphify . --update at end of session` - 6 edges

## Surprising Connections (you probably didn't know these)
- `Plugin Architecture: lazy.nvim Auto-Discovery of nvim/lua/plugins/` --semantically_similar_to--> `lazy.nvim (plugin manager)`  [INFERRED] [semantically similar]
  CLAUDE.md → README.md
- `mason-lspconfig` --semantically_similar_to--> `mason`  [INFERRED] [semantically similar]
  CLAUDE.md → README.md
- `Quick Start (new machine) install steps` --semantically_similar_to--> `install.sh Gotchas: apt/npm conflict avoidance, numeric Neovim version compare, timestamped backups`  [INFERRED] [semantically similar]
  README.md → CLAUDE.md
- `macOS install branch (Homebrew packages, brew-managed Neovim, ghostty symlink)` --semantically_similar_to--> `macOS support in install.sh (Homebrew branch)`  [INFERRED] [semantically similar]
  README.md → CLAUDE.md
- `Tmux Quickstart Keybindings (prefix Ctrl-a)` --conceptually_related_to--> `tmux/tmux.conf`  [INFERRED]
  README.md → CLAUDE.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Multi-Theme Switching System** — docs_superpowers_plans_2026_05_07_theme_switcher_new_colorscheme_plugins, docs_superpowers_plans_2026_05_07_theme_switcher_orchestrator, docs_superpowers_specs_2026_05_07_theme_switcher_design_orchestrator_api [INFERRED 0.75]
- **Superpowers Plan/Spec Documentation Pattern** — docs_superpowers_plans_2026_05_06_indent_guides_toggle_doc, docs_superpowers_specs_2026_05_06_indent_guides_toggle_design_doc, docs_superpowers_plans_2026_05_07_theme_switcher_doc, docs_superpowers_specs_2026_05_07_theme_switcher_design_doc [INFERRED 0.85]
- **Motion and editing plugins (flash, surround, mini.ai)** — claude_flash_nvim, claude_nvim_surround, readme_mini_ai [EXTRACTED 1.00]
- **macOS support stack (Homebrew install branch, Ghostty config, Option-as-Alt)** — claude_macos_homebrew_support, claude_ghostty_config, claude_macos_option_alt, claude_pane_navigation_invariant [INFERRED 0.85]
- **Tmux session persistence via TPM (resurrect + continuum)** — claude_tpm_concept, claude_tmux_resurrect, claude_tmux_continuum [EXTRACTED 1.00]

## Communities (43 total, 30 thin omitted)

### Community 0 - "Repo Conventions & Tmux"
Cohesion: 0.12
Nodes (21): Catppuccin Highlights Applied Twice: ColorScheme Autocmd Is Load-Bearing (some plugins re-apply highlights after setup() and would clobber the first pass), Cross-File Invariants (keep paired files in sync), ghostty/config.ghostty, Knowledge Graph (graphify) Update Workflow: run /graphify . --update at end of session, Leader keymaps must be declared in which-key.lua spec, macos-option-as-alt = left, Tmux-nvim pane navigation invariant, Reload-After-Editing Workflow Table (+13 more)

### Community 1 - "Theme Switcher Design"
Cohesion: 0.13
Nodes (21): Catppuccin Setup Extraction into themes/catppuccin.lua, Atomic Cutover (Task 5), Theme Switcher Implementation Plan, Three New Colorscheme Plugin Installs (kanagawa, rose-pine, vscode), Theme Orchestrator (themes/init.lua), Theme + Transparency Persistence (theme.json), Theme Adapter Modules (kanagawa, rose_pine, vscode), Two-Layer Architecture (plugin specs vs theme modules) (+13 more)

### Community 2 - "Editor Features & Motions"
Cohesion: 0.14
Nodes (17): flash.nvim, nvim-surround, Visual-mode S belongs to nvim-surround, flash binds S only in normal/operator-pending, bufferline, catppuccin-mocha theme, fugitive, gitsigns, grug-far.nvim (+9 more)

### Community 3 - "Plugin Architecture & Init"
Cohesion: 0.15
Nodes (11): Plugin Architecture: lazy.nvim Auto-Discovery of nvim/lua/plugins/, lazy, nvim/lazy-lock.json, nvim/lua/plugins/ (directory), nvim/lua/plugins.lua (intentionally empty, shadowed), Claude Code tmux pane workflow, lazy.nvim (plugin manager), Tmux Quickstart Keybindings (prefix Ctrl-a) (+3 more)

### Community 4 - "Indent Guides Toggle Spec"
Cohesion: 0.20
Nodes (14): catppuccin ibl Integration Line, Indent Guides Toggle Implementation Plan, indent-blankline.nvim Plugin Spec (ibl v3), <leader>i Indent Guides Toggle Keymap, Manual E2E Verification Checklist (Task 4), which-key Entry for <leader>i, Toggle Behavior Summary (off by default, global, resets on restart), catppuccin indent_blankline Integration (+6 more)

### Community 5 - "Install Script & macOS"
Cohesion: 0.29
Nodes (12): install.sh Gotchas: apt/npm conflict avoidance, numeric Neovim version compare, timestamped backups, macOS support in install.sh (Homebrew branch), ext_usr_lib_os_release, backup_then_link(), color(), info(), is_apt_family(), install.sh script (+4 more)

### Community 6 - "LSP, Telescope & Nav"
Cohesion: 0.18
Nodes (8): mason-lspconfig, cmp_nvim_lsp, mason, mason_registry, LSP servers: lua, ts, html, pyright, bash, mason, telescope_builtin, telescope_themes

### Community 7 - "Treesitter & Queries"
Cohesion: 0.27
Nodes (9): ensure_installed lists are independent (lsp-config.lua and treesitter.lua), Treesitter Python Parser Pinned to master + Custom Query Overrides (upstream indent query doesn't compile against master parser, breaking indentation), nvim/queries/ (directory, treesitter query overrides), nvim/queries/python/highlights.scm, nvim/queries/python/indents.scm, nvim_treesitter_configs, nvim_treesitter_parsers, nvim_treesitter_query_predicates (+1 more)

### Community 8 - "Theme Orchestrator Code"
Cohesion: 0.42
Nodes (6): load_persisted(), M.set(), M.setup(), M.toggle_transparency(), persist_path(), save()

### Community 9 - "Completion & Autopairs"
Cohesion: 0.29
Nodes (5): cmp, luasnip, luasnip_loaders_from_vscode, nvim_autopairs, nvim_autopairs_completion_cmp

### Community 10 - "Find-Files Keymap Spec"
Cohesion: 0.33
Nodes (6): Find-Files Keymap Design Spec, Move find_files Binding from <C-p> to <leader>ff, Out of Scope (alpha dashboard buttons, search-within-file, neo-tree keymaps, doc updates), Risks (muscle memory transition, one-line revert), Verification Steps (syntax check, which-key popup, keypress checks), which-key

### Community 11 - "conform Formatting"
Cohesion: 0.70
Nodes (5): conform.nvim (conform.lua), Format on save (except Markdown), toggle with <leader>uf, Formatting via conform.nvim (stylua + prettier + LSP fallback), bound to <leader>gf, prettier, stylua

### Community 12 - "XLSX Viewer"
Cohesion: 0.50
Nodes (3): csvview, convert(), load_xlsx()

## Knowledge Gaps
- **24 isolated node(s):** `<leader>i Indent Guides Toggle Keymap`, `Out of Scope (alpha dashboard buttons, search-within-file, neo-tree keymaps, doc updates)`, `Risks (muscle memory transition, one-line revert)`, `Verification Steps (syntax check, which-key popup, keypress checks)`, `Risks (first-press latency, highlight clash, reversibility)` (+19 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 83 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **30 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Highlights: Editor Feature Set` connect `Editor Features & Motions` to `Repo Conventions & Tmux`, `Plugin Architecture & Init`, `LSP, Telescope & Nav`, `Treesitter & Queries`, `Find-Files Keymap Spec`, `conform Formatting`?**
  _High betweenness centrality (0.257) - this node is a cross-community bridge._
- **Why does `Move find_files Binding from <C-p> to <leader>ff` connect `Find-Files Keymap Spec` to `Indent Guides Toggle Spec`?**
  _High betweenness centrality (0.214) - this node is a cross-community bridge._
- **Why does `which-key` connect `Find-Files Keymap Spec` to `Repo Conventions & Tmux`, `Editor Features & Motions`?**
  _High betweenness centrality (0.212) - this node is a cross-community bridge._
- **What connects `<leader>i Indent Guides Toggle Keymap`, `Out of Scope (alpha dashboard buttons, search-within-file, neo-tree keymaps, doc updates)`, `Risks (muscle memory transition, one-line revert)` to the rest of the system?**
  _24 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Repo Conventions & Tmux` be split into smaller, more focused modules?**
  _Cohesion score 0.12 - nodes in this community are weakly interconnected._
- **Should `Theme Switcher Design` be split into smaller, more focused modules?**
  _Cohesion score 0.13333333333333333 - nodes in this community are weakly interconnected._
- **Should `Editor Features & Motions` be split into smaller, more focused modules?**
  _Cohesion score 0.13970588235294118 - nodes in this community are weakly interconnected._