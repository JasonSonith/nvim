# nvim — my Neovim + tmux setup

Personal Neovim + tmux configuration that turns a terminal into a VSCode-style coding environment, with a side workflow for Claude Code in a tmux pane.

Works on macOS, WSL2 Ubuntu, regular Ubuntu, Debian, Kali, Fedora, Arch.

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
├── ghostty/              # contents of ~/.config/ghostty on macOS
│   └── config.ghostty
├── install.sh            # symlinks configs into $HOME, installs deps
└── README.md
```

## Quick start (new machine)

On macOS, install [Homebrew](https://brew.sh) before running the installer.

```bash
git clone git@github.com:JasonSonith/nvim.git ~/nvim-config
cd ~/nvim-config
./install.sh
```

The installer:
1. Installs system packages with apt, dnf, or pacman on Linux; on macOS, Homebrew installs `git`, `neovim`, `tmux`, `ripgrep`, `fd`, `python`, `pipx`, `node` if missing, Ghostty, and the JetBrains Mono Nerd Font.
2. Ensures Neovim is at least v0.11. On Linux, it downloads the latest release tarball if needed; on macOS, it suggests `brew upgrade neovim` if the brew version is too old.
3. Symlinks `~/.config/nvim` → `nvim-config/nvim`, `~/.tmux.conf` → `nvim-config/tmux/tmux.conf`, and on macOS `~/.config/ghostty` → `nvim-config/ghostty` (existing files are backed up with a timestamp suffix).
4. Installs `xlsx2csv` with pip3 on Linux or pipx on macOS, bootstraps tmux plugins, syncs Neovim plugins, and updates Treesitter parsers.

After that:
- `tmux` to start a session, `Ctrl-a e` to split nvim + Claude side-by-side.
- `nvim .` to open a directory tree.

## macOS notes

- Ghostty is the terminal this config targets. `ghostty/config.ghostty` sets left Option as Alt, so `Option-h/j/k/l` moves between tmux panes and nvim splits; right Option still types symbols.
- In tmux copy mode (`prefix [`, then `v`, then `y`), the selection should land in the macOS clipboard.
- Icons in the bufferline and statusline should render; Ghostty has Nerd Font symbols built in.
- `infocmp tmux-256color` should print an entry. If it errors, the system terminfo is missing it and tmux panes will misbehave.
- If the xlsx viewer reports `xlsx2csv not found`, run `pipx ensurepath` and restart the shell.

## Highlights

- **Plugin manager:** lazy.nvim (auto-installs on first launch)
- **Theme:** catppuccin-mocha, transparent editor, solid panels
- **Tabs:** bufferline at the top, `Tab` / `Shift-Tab` to cycle
- **File tree:** neo-tree on the left (`Ctrl-n` toggle)
- **Fuzzy finder:** telescope (`Ctrl-p` files, `<Space>fg` grep)
- **LSP:** mason + nvim-lspconfig (lua, ts, html, pyright, bash)
- **Completion:** nvim-cmp + LuaSnip
- **Formatting:** conform.nvim with Stylua, Prettier, and LSP fallback (`<Space>gf`)
- **Motions and editing:** flash.nvim, nvim-surround, and mini.ai
- **Search and replace:** grug-far.nvim (`<Space>sr`)
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

- macOS with Homebrew, Linux, or WSL2
- Bash
- A terminal with truecolor + (optional) transparency support — Ghostty on macOS, Windows Terminal, Wezterm, Alacritty, Kitty, etc.

## License

Personal config — use freely.
