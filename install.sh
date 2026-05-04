#!/usr/bin/env bash
# install.sh — set up Jason's Neovim + tmux config on a fresh machine
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS=$(date +%s)

color() { printf "\033[1;36m%s\033[0m\n" "$1"; }
warn()  { printf "\033[1;33m%s\033[0m\n" "$1"; }

color "==> Installing system packages"
if command -v apt >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y \
    git curl tar unzip build-essential \
    tmux \
    ripgrep fd-find \
    python3 python3-pip python3-venv \
    nodejs npm
elif command -v dnf >/dev/null 2>&1; then
  sudo dnf install -y git curl tar unzip make gcc gcc-c++ tmux ripgrep fd-find python3 python3-pip nodejs npm
elif command -v pacman >/dev/null 2>&1; then
  sudo pacman -Sy --noconfirm git curl tar unzip base-devel tmux ripgrep fd python python-pip nodejs npm
else
  warn "Unknown package manager. Install manually: git, curl, tmux, ripgrep, fd, python3, nodejs, npm, build tools."
fi

color "==> Installing Neovim (if missing or outdated)"
need_install=1
if command -v nvim >/dev/null 2>&1; then
  current=$(nvim --version | head -1 | awk '{print $2}')
  if [[ "$current" > "v0.9.99" ]]; then
    need_install=0
    echo "    nvim ${current} already present"
  fi
fi
if [[ $need_install -eq 1 ]]; then
  arch=$(uname -m)
  case "$arch" in
    x86_64) tarball="nvim-linux-x86_64.tar.gz" ;;
    aarch64|arm64) tarball="nvim-linux-arm64.tar.gz" ;;
    *) warn "Unsupported arch: $arch. Install Neovim manually."; tarball="" ;;
  esac
  if [[ -n "$tarball" ]]; then
    curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/${tarball}" -o "/tmp/${tarball}"
    sudo tar -C /opt -xzf "/tmp/${tarball}"
    extracted_dir=$(tar -tzf "/tmp/${tarball}" | head -1 | cut -d/ -f1)
    sudo ln -sf "/opt/${extracted_dir}/bin/nvim" /usr/local/bin/nvim
    rm "/tmp/${tarball}"
    echo "    installed nvim -> /usr/local/bin/nvim"
  fi
fi

color "==> Symlinking configs"
mkdir -p "$HOME/.config"

backup_then_link() {
  local src="$1" dst="$2"
  if [[ -L "$dst" ]]; then
    rm "$dst"
  elif [[ -e "$dst" ]]; then
    mv "$dst" "${dst}.bak.${TS}"
    echo "    backed up: ${dst} -> ${dst}.bak.${TS}"
  fi
  ln -s "$src" "$dst"
  echo "    linked: $src -> $dst"
}

backup_then_link "${DOTFILES_DIR}/nvim" "$HOME/.config/nvim"
backup_then_link "${DOTFILES_DIR}/tmux/tmux.conf" "$HOME/.tmux.conf"

color "==> Bootstrapping Neovim plugins (this may take a minute)"
nvim --headless "+Lazy! sync" "+qa" 2>/dev/null || true
nvim --headless "+TSUpdateSync" "+qa" 2>/dev/null || true

color "==> Done"
cat <<EOF

Next steps:
  tmux              # start a session
  prefix is Ctrl-a (not Ctrl-b). Inside tmux:
    Ctrl-a e        # split: nvim on the left, claude on the right
    Ctrl-a |        # vertical split,  Ctrl-a -  horizontal split
    Ctrl-a r        # reload tmux config

  nvim .            # open the project tree
  press Space and wait to see the keymap popup (which-key)

For modes / motions / cheat sheets, see your Obsidian vault: Neovim/ folder.
EOF
