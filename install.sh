#!/usr/bin/env bash
# install.sh — set up Jason's Neovim + tmux config on a fresh machine
# Supports: Ubuntu / Debian / Kali / Mint (apt), Fedora / RHEL (dnf), Arch (pacman)
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS=$(date +%s)

color() { printf "\033[1;36m%s\033[0m\n" "$1"; }
warn()  { printf "\033[1;33m%s\033[0m\n" "$1"; }
info()  { printf "    %s\n" "$1"; }

# ---------- Detect distro ----------
DISTRO_ID=""
DISTRO_LIKE=""
DISTRO_PRETTY="unknown"
if [[ -f /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  DISTRO_ID="${ID:-}"
  DISTRO_LIKE="${ID_LIKE:-}"
  DISTRO_PRETTY="${PRETTY_NAME:-$ID}"
fi
color "==> Detected: ${DISTRO_PRETTY}"

# ---------- sudo wrapper (no-op when running as root) ----------
if [[ $EUID -eq 0 ]]; then
  SUDO=""
  info "running as root — skipping sudo"
else
  if ! command -v sudo >/dev/null 2>&1; then
    warn "sudo not installed and you are not root. Install sudo or re-run as root."
    exit 1
  fi
  SUDO="sudo"
fi

# ---------- Package manager dispatch ----------
is_apt_family() {
  case "$DISTRO_ID" in ubuntu|debian|kali|linuxmint|pop|elementary|raspbian) return 0 ;; esac
  case " $DISTRO_LIKE " in *" debian "*|*" ubuntu "*) return 0 ;; esac
  return 1
}

color "==> Installing system packages"
if is_apt_family || command -v apt >/dev/null 2>&1; then
  info "package manager: apt (${DISTRO_ID:-debian-family})"
  $SUDO apt update

  PKGS=(
    git curl wget tar unzip ca-certificates
    build-essential pkg-config
    tmux
    ripgrep fd-find
    python3 python3-pip python3-venv
  )

  # Kali-only nice-to-haves (skip silently on others)
  if [[ "$DISTRO_ID" == "kali" ]]; then
    PKGS+=(xclip)  # for nvim clipboard integration on Kali Xorg sessions
  fi

  # Decide whether to ask apt for nodejs/npm. If a modern Node is already installed
  # (e.g. from NodeSource), apt's npm Conflicts with it — adding both to PKGS makes
  # the entire install fail with unsatisfiable dependencies.
  NODE_OK=0
  if command -v node >/dev/null 2>&1 && command -v npm >/dev/null 2>&1; then
    EXISTING_NODE_MAJOR=$(node -p 'process.versions.node.split(".")[0]' 2>/dev/null || echo 0)
    if (( EXISTING_NODE_MAJOR >= 18 )); then
      NODE_OK=1
      info "node $(node -v) and npm $(npm -v) already installed — skipping apt nodejs/npm"
    fi
  fi
  if (( NODE_OK == 0 )); then
    PKGS+=(nodejs npm)
  fi

  $SUDO apt install -y "${PKGS[@]}"

  # If we DID just install Node from apt and it's still too old, upgrade via NodeSource.
  # On Ubuntu 22.04 apt's nodejs is 12.x; NodeSource ships current LTS.
  if (( NODE_OK == 0 )) && command -v node >/dev/null 2>&1; then
    NODE_MAJOR=$(node -p 'process.versions.node.split(".")[0]' 2>/dev/null || echo 0)
    if (( NODE_MAJOR < 18 )); then
      warn "Node ${NODE_MAJOR} is too old. Upgrading via NodeSource…"
      curl -fsSL https://deb.nodesource.com/setup_20.x | $SUDO -E bash -
      $SUDO apt install -y nodejs
    else
      info "node $(node -v) — OK"
    fi
  fi

  # Stale NodeSource sources can break `apt update` after Kali tightened SHA1 policy
  # (Feb 2026). Just warn — don't auto-remove user's apt sources.
  if grep -rqsE "deb\.nodesource\.com.*node_(1[0-7])\.x" /etc/apt/sources.list.d/ 2>/dev/null; then
    warn "Old NodeSource source detected in /etc/apt/sources.list.d/. May cause noisy SHA1 warnings during apt update."
    warn "  Fix: sudo rm /etc/apt/sources.list.d/nodesource.list (and /etc/apt/keyrings/nodesource.gpg)"
  fi

  # Some Debian-family installs only put fd at /usr/bin/fdfind — symlink for sanity
  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    $SUDO ln -sf "$(command -v fdfind)" /usr/local/bin/fd
    info "linked fdfind -> fd"
  fi

elif command -v dnf >/dev/null 2>&1; then
  info "package manager: dnf"
  $SUDO dnf install -y git curl wget tar unzip make gcc gcc-c++ pkgconfig tmux ripgrep fd-find python3 python3-pip nodejs npm

elif command -v pacman >/dev/null 2>&1; then
  info "package manager: pacman"
  $SUDO pacman -Sy --noconfirm git curl wget tar unzip base-devel pkgconf tmux ripgrep fd python python-pip nodejs npm

else
  warn "Unknown package manager. Install manually: git, curl, tmux, ripgrep, fd, python3, nodejs (>=18), npm, build tools."
fi

# ---------- Neovim ----------
# Require >= 0.10. Compare numerically (string compare gets "0.11" < "0.9" wrong).
NVIM_MIN_MAJOR=0
NVIM_MIN_MINOR=10

color "==> Installing Neovim (if missing or outdated)"
need_install=1
if command -v nvim >/dev/null 2>&1; then
  current_full=$(nvim --version | head -1 | awk '{print $2}')                 # e.g. "v0.11.6"
  current_clean="${current_full#v}"                                           # "0.11.6"
  current_major="${current_clean%%.*}"
  rest="${current_clean#*.}"
  current_minor="${rest%%.*}"
  if (( current_major > NVIM_MIN_MAJOR )) || \
     (( current_major == NVIM_MIN_MAJOR && current_minor >= NVIM_MIN_MINOR )); then
    need_install=0
    info "nvim ${current_full} already present"
  else
    info "nvim ${current_full} is below ${NVIM_MIN_MAJOR}.${NVIM_MIN_MINOR}, replacing"
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
    info "downloading $tarball"
    if ! curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/${tarball}" -o "/tmp/${tarball}"; then
      warn "Failed to download Neovim. Check network. Continuing with whatever nvim is on PATH."
    else
      $SUDO tar -C /opt -xzf "/tmp/${tarball}"
      # Derive the extracted dir from the tarball name. `tar -tzf | head -1`
      # overflows the pipe buffer on large archives; head closes early, tar
      # dies with SIGPIPE (141), pipefail surfaces it, set -e kills silently.
      extracted_dir="${tarball%.tar.gz}"
      $SUDO ln -sf "/opt/${extracted_dir}/bin/nvim" /usr/local/bin/nvim
      rm "/tmp/${tarball}"
      info "installed nvim -> /usr/local/bin/nvim ($(/usr/local/bin/nvim --version | head -1 | awk '{print $2}'))"
    fi
  fi
fi

# ---------- Symlinks ----------
color "==> Symlinking configs"
mkdir -p "$HOME/.config"

backup_then_link() {
  local src="$1" dst="$2"
  if [[ -L "$dst" ]]; then
    rm "$dst"
  elif [[ -e "$dst" ]]; then
    mv "$dst" "${dst}.bak.${TS}"
    info "backed up: ${dst} -> ${dst}.bak.${TS}"
  fi
  ln -s "$src" "$dst"
  info "linked: $src -> $dst"
}

backup_then_link "${DOTFILES_DIR}/nvim" "$HOME/.config/nvim"
backup_then_link "${DOTFILES_DIR}/tmux/tmux.conf" "$HOME/.tmux.conf"

# ---------- Tmux plugins (TPM: tmux-resurrect, tmux-continuum) ----------
color "==> Bootstrapping tmux plugins (TPM)"
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ -d "$TPM_DIR/.git" ]]; then
  info "TPM already present at $TPM_DIR"
else
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
  info "cloned TPM to $TPM_DIR"
fi
# install_plugins reads TMUX_PLUGIN_MANAGER_PATH from the tmux server's global env.
# That var is only set once TPM has been loaded from tmux.conf, so set it manually
# here (start-server is a no-op if a server is already running).
tmux start-server \; set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins/" 2>/dev/null || true
if "$TPM_DIR/bin/install_plugins" >/dev/null 2>&1; then
  info "tmux plugins installed (resurrect, continuum)"
else
  warn "TPM install_plugins failed — press prefix+I inside tmux to retry"
fi

# ---------- Python tools used by nvim ----------
color "==> Installing Python helpers (xlsx2csv)"
if command -v pip3 >/dev/null 2>&1; then
  pip3 install --user --quiet --break-system-packages xlsx2csv 2>/dev/null \
    || pip3 install --user --quiet xlsx2csv \
    || warn "pip3 install xlsx2csv failed — xlsx viewing in nvim won't work until you install it manually"
else
  warn "pip3 not found — skip xlsx2csv install"
fi

color "==> Bootstrapping Neovim plugins (may take a minute)"
nvim --headless "+Lazy! sync" "+qa" 2>/dev/null || true
nvim --headless "+TSUpdateSync" "+qa" 2>/dev/null || true

# ---------- Done ----------
color "==> Done"
cat <<EOF

Distro:    ${DISTRO_PRETTY}
nvim:      $(command -v nvim) ($(nvim --version | head -1 | awk '{print $2}'))
tmux:      $(command -v tmux) ($(tmux -V | awk '{print $2}'))
node:      $(command -v node 2>/dev/null || echo "(not installed)") $(node --version 2>/dev/null || echo "")

Next steps:
  tmux              # start a session
  prefix is Ctrl-a (not Ctrl-b). Inside tmux:
    Ctrl-a e        # split: nvim on the left, claude on the right
    Ctrl-a |        # vertical split,  Ctrl-a -  horizontal split
    Ctrl-a r        # reload tmux config

  nvim .            # open the project tree
  Press Space and wait to see the keymap popup (which-key)

For modes / motions / cheat sheets, see your Obsidian vault: Neovim/ folder.
EOF
