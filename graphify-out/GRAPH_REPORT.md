# Graph Report - nvim  (2026-10-15)

## Corpus Check
- 56 files · ~20,055 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 198 nodes · 233 edges · 56 communities (44 shown, 12 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 24 edges (avg confidence: 0.86)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `59dc2724`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- README.md
- Theme Switcher Design Spec
- Highlights: Editor Feature Set
- Indent Guides Toggle Design Spec
- install.sh
- lsp-config.lua
- treesitter.lua
- themes/init.lua
- completions.lua
- Find-Files Keymap Design Spec
- conform.nvim (conform.lua)
- xlsx-viewer.lua
- Cross-File Invariants (keep paired files in sync)
- nvim_autopairs_completion_cmp
- ext_usr_lib_os_release
- lazy
- luasnip_loaders_from_vscode
- mason
- nvim_autopairs
- nvim_treesitter_configs
- nvim_treesitter_query_predicates
- nvim_ts_autotag
- telescope_themes
- themes

## God Nodes (most connected - your core abstractions)
1. `Highlights: Editor Feature Set` - 23 edges
2. `Cross-File Invariants (keep paired files in sync)` - 12 edges
3. `Theme Switcher Design Spec` - 11 edges
4. `Theme Switcher Implementation Plan` - 9 edges
5. `Indent Guides Toggle Design Spec` - 9 edges
6. `tmux/tmux.conf` - 8 edges
7. `install.sh script` - 6 edges
8. `Indent Guides Toggle Implementation Plan` - 6 edges
9. `Knowledge Graph (graphify) Update Workflow: run /graphify . --update at end of session` - 6 edges
10. `Tmux Plugin Management via TPM` - 6 edges

## Surprising Connections (you probably didn't know these)
- `Plugin Architecture: lazy.nvim Auto-Discovery of nvim/lua/plugins/` --semantically_similar_to--> `lazy.nvim (plugin manager)`  [INFERRED] [semantically similar]
  CLAUDE.md → README.md
- `Quick Start (new machine) install steps` --semantically_similar_to--> `install.sh Gotchas: apt/npm conflict avoidance, numeric Neovim version compare, timestamped backups`  [INFERRED] [semantically similar]
  README.md → CLAUDE.md
- `macOS install branch (Homebrew packages, brew-managed Neovim, ghostty symlink)` --semantically_similar_to--> `macOS support in install.sh (Homebrew branch)`  [INFERRED] [semantically similar]
  README.md → CLAUDE.md
- `mason-lspconfig` --semantically_similar_to--> `mason`  [INFERRED] [semantically similar]
  CLAUDE.md → README.md
- `Move find_files Binding from <C-p> to <leader>ff` --conceptually_related_to--> `which-key`  [INFERRED]
  docs/superpowers/specs/2026-05-06-find-files-keymap-design.md → README.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Motion and editing plugins (flash, surround, mini.ai)** — claude_flash_nvim, claude_nvim_surround, readme_mini_ai [EXTRACTED 1.00]
- **Tmux session persistence via TPM (resurrect + continuum)** — claude_tpm_concept, claude_tmux_resurrect, claude_tmux_continuum [EXTRACTED 1.00]
- **Multi-Theme Switching System** — docs_superpowers_plans_2026_05_07_theme_switcher_new_colorscheme_plugins, docs_superpowers_plans_2026_05_07_theme_switcher_orchestrator, docs_superpowers_specs_2026_05_07_theme_switcher_design_orchestrator_api [INFERRED 0.75]
- **macOS support stack (Homebrew install branch, Ghostty config, Option-as-Alt)** — claude_macos_homebrew_support, claude_ghostty_config, claude_macos_option_alt, claude_pane_navigation_invariant [INFERRED 0.85]
- **Superpowers Plan/Spec Documentation Pattern** — docs_superpowers_plans_2026_05_06_indent_guides_toggle_doc, docs_superpowers_specs_2026_05_06_indent_guides_toggle_design_doc, docs_superpowers_plans_2026_05_07_theme_switcher_doc, docs_superpowers_specs_2026_05_07_theme_switcher_design_doc [INFERRED 0.85]

## Communities (56 total, 12 thin omitted)

### Community 0 - "README.md"
Cohesion: 0.11
Nodes (21): Knowledge Graph (graphify) Update Workflow: run /graphify . --update at end of session, Plugin Architecture: lazy.nvim Auto-Discovery of nvim/lua/plugins/, Reload-After-Editing Workflow Table, Repo Purpose: Dotfiles Are the Live Config (no build step, no tests), tmux-continuum, Tmux Plugin Management via TPM, tmux-resurrect, TPM (Tmux Plugin Manager) (+13 more)

### Community 1 - "Theme Switcher Design Spec"
Cohesion: 0.13
Nodes (21): Catppuccin Setup Extraction into themes/catppuccin.lua, Atomic Cutover (Task 5), Theme Switcher Implementation Plan, Three New Colorscheme Plugin Installs (kanagawa, rose-pine, vscode), Theme Orchestrator (themes/init.lua), Theme + Transparency Persistence (theme.json), Theme Adapter Modules (kanagawa, rose_pine, vscode), Two-Layer Architecture (plugin specs vs theme modules) (+13 more)

### Community 2 - "Highlights: Editor Feature Set"
Cohesion: 0.14
Nodes (17): flash.nvim, nvim-surround, Visual-mode S belongs to nvim-surround, flash binds S only in normal/operator-pending, bufferline, catppuccin-mocha theme, fugitive, gitsigns, grug-far.nvim (+9 more)

### Community 4 - "Indent Guides Toggle Design Spec"
Cohesion: 0.20
Nodes (14): catppuccin ibl Integration Line, Indent Guides Toggle Implementation Plan, indent-blankline.nvim Plugin Spec (ibl v3), <leader>i Indent Guides Toggle Keymap, Manual E2E Verification Checklist (Task 4), which-key Entry for <leader>i, Toggle Behavior Summary (off by default, global, resets on restart), catppuccin indent_blankline Integration (+6 more)

### Community 5 - "install.sh"
Cohesion: 0.33
Nodes (11): install.sh Gotchas: apt/npm conflict avoidance, numeric Neovim version compare, timestamped backups, macOS support in install.sh (Homebrew branch), backup_then_link(), color(), info(), is_apt_family(), install.sh script, warn() (+3 more)

### Community 6 - "lsp-config.lua"
Cohesion: 0.22
Nodes (6): mason-lspconfig, cmp_nvim_lsp, mason_registry, LSP servers: lua, ts, html, pyright, bash, mason, telescope_builtin

### Community 7 - "treesitter.lua"
Cohesion: 0.36
Nodes (7): ensure_installed lists are independent (lsp-config.lua and treesitter.lua), Treesitter Python Parser Pinned to master + Custom Query Overrides (upstream indent query doesn't compile against master parser, breaking indentation), nvim/queries/ (directory, treesitter query overrides), nvim/queries/python/highlights.scm, nvim/queries/python/indents.scm, nvim_treesitter_parsers, treesitter (master branch)

### Community 8 - "themes/init.lua"
Cohesion: 0.42
Nodes (6): load_persisted(), M.set(), M.setup(), M.toggle_transparency(), persist_path(), save()

### Community 10 - "Find-Files Keymap Design Spec"
Cohesion: 0.33
Nodes (6): Find-Files Keymap Design Spec, Move find_files Binding from <C-p> to <leader>ff, Out of Scope (alpha dashboard buttons, search-within-file, neo-tree keymaps, doc updates), Risks (muscle memory transition, one-line revert), Verification Steps (syntax check, which-key popup, keypress checks), which-key

### Community 11 - "conform.nvim (conform.lua)"
Cohesion: 0.70
Nodes (5): conform.nvim (conform.lua), Format on save (except Markdown), toggle with <leader>uf, Formatting via conform.nvim (stylua + prettier + LSP fallback), bound to <leader>gf, prettier, stylua

### Community 12 - "xlsx-viewer.lua"
Cohesion: 0.50
Nodes (3): csvview, convert(), load_xlsx()

### Community 43 - "Cross-File Invariants (keep paired files in sync)"
Cohesion: 0.26
Nodes (9): Catppuccin Highlights Applied Twice: ColorScheme Autocmd Is Load-Bearing (some plugins re-apply highlights after setup() and would clobber the first pass), Cross-File Invariants (keep paired files in sync), ghostty/config.ghostty, Leader keymaps must be declared in which-key.lua spec, macos-option-as-alt = left, Tmux-nvim pane navigation invariant, Ghostty terminal, macOS post-install checklist (+1 more)

## Knowledge Gaps
- **24 isolated node(s):** `Risks (transparency toggle glitch, rose-pine polarity confusion, plugin rename, reversibility)`, `Out of Scope (alpha dashboard buttons, search-within-file, neo-tree keymaps, doc updates)`, `Risks (muscle memory transition, one-line revert)`, `Verification Steps (syntax check, which-key popup, keypress checks)`, `<leader>i Indent Guides Toggle Keymap` (+19 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **12 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Highlights: Editor Feature Set` connect `Highlights: Editor Feature Set` to `README.md`, `lsp-config.lua`, `treesitter.lua`, `Find-Files Keymap Design Spec`, `Cross-File Invariants (keep paired files in sync)`, `conform.nvim (conform.lua)`?**
  _High betweenness centrality (0.225) - this node is a cross-community bridge._
- **Why does `Move find_files Binding from <C-p> to <leader>ff` connect `Find-Files Keymap Design Spec` to `Indent Guides Toggle Design Spec`?**
  _High betweenness centrality (0.191) - this node is a cross-community bridge._
- **Why does `which-key` connect `Find-Files Keymap Design Spec` to `Highlights: Editor Feature Set`, `Cross-File Invariants (keep paired files in sync)`?**
  _High betweenness centrality (0.189) - this node is a cross-community bridge._
- **What connects `Risks (transparency toggle glitch, rose-pine polarity confusion, plugin rename, reversibility)`, `Out of Scope (alpha dashboard buttons, search-within-file, neo-tree keymaps, doc updates)`, `Risks (muscle memory transition, one-line revert)` to the rest of the system?**
  _24 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `README.md` be split into smaller, more focused modules?**
  _Cohesion score 0.10541310541310542 - nodes in this community are weakly interconnected._
- **Should `Theme Switcher Design Spec` be split into smaller, more focused modules?**
  _Cohesion score 0.13333333333333333 - nodes in this community are weakly interconnected._
- **Should `Highlights: Editor Feature Set` be split into smaller, more focused modules?**
  _Cohesion score 0.13970588235294118 - nodes in this community are weakly interconnected._