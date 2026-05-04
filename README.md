# nvim — my Neovim + tmux setup

Personal Neovim + tmux configuration that turns a terminal into a VSCode-style coding environment, with a side workflow for Claude Code in a tmux pane.

Works on WSL2 Ubuntu, regular Ubuntu, Debian, Kali, Fedora, Arch.

## What's inside

```
.
├── nvim/                 # contents of ~/.config/nvim
│   ├── init.lua
│   ├── lazy-lock.json
│   ├── lua/
│   │   ├── vim-options.lua
│   │   └── plugins/      # one file per plugin
│   └── queries/          # treesitter query overrides
├── tmux/
│   └── tmux.conf         # contents of ~/.tmux.conf
├── install.sh            # symlinks configs into $HOME, installs deps
└── README.md
```

## Quick start (new machine)

```bash
git clone git@github.com:JasonSonith/nvim.git ~/nvim-config
cd ~/nvim-config
./install.sh
```

The installer:
1. Installs system packages: `git`, `tmux`, `ripgrep`, `fd`, `nodejs`, `npm`, `python3`, build tools.
2. Installs the latest Neovim binary (if not already ≥ v0.10).
3. Symlinks `~/.config/nvim` → `nvim-config/nvim`, `~/.tmux.conf` → `nvim-config/tmux/tmux.conf` (existing files are backed up with a timestamp suffix).
4. Bootstraps Neovim plugins via `lazy.nvim` and updates Treesitter parsers.

After that:
- `tmux` to start a session, `Ctrl-a e` to split nvim + Claude side-by-side.
- `nvim .` to open a directory tree.

## Highlights

- **Plugin manager:** lazy.nvim (auto-installs on first launch)
- **Theme:** catppuccin-mocha, transparent editor, solid panels
- **Tabs:** bufferline at the top, `Tab` / `Shift-Tab` to cycle
- **File tree:** neo-tree on the left (`Ctrl-n` toggle)
- **Fuzzy finder:** telescope (`Ctrl-p` files, `<Space>fg` grep)
- **LSP:** mason + nvim-lspconfig (lua, ts, html, pyright, bash)
- **Completion:** nvim-cmp + LuaSnip
- **Git:** gitsigns + fugitive
- **Syntax:** treesitter on master branch, with a few query overrides
- **Sticky context:** treesitter-context shows the enclosing function/class as you scroll
- **Cursor smear:** sphamba/smear-cursor.nvim
- **Which-key:** popup of available keymaps when you press a leader prefix
- **Tmux nav:** alexghergh/nvim-tmux-navigation — `Ctrl-h/j/k/l` jumps between nvim splits and tmux panes seamlessly

## Tmux quickstart

Prefix is `Ctrl-a` (not the default `Ctrl-b`).

| Keys | Action |
|---|---|
| `prefix e` | open nvim left, claude right |
| `prefix c` | spawn claude on the right of current pane |
| `prefix |` / `prefix -` | vertical / horizontal split |
| `prefix z` | zoom the current pane to fullscreen |
| `prefix b` | break current pane to its own window |
| `prefix j` | join a window's pane back as a split |
| `prefix Tab` | jump to last-used pane |
| `prefix r` | reload tmux.conf |

## Updating

```bash
cd ~/nvim-config
git pull
nvim --headless "+Lazy! sync" "+TSUpdateSync" "+qa"
```

## Dependencies

- Linux or WSL2
- Bash
- A terminal with truecolor + (optional) transparency support — Windows Terminal, Wezterm, Alacritty, Kitty, etc.

## License

Personal config — use freely.
