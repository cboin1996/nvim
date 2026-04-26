#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log()  { echo -e "${GREEN}==>${NC} $1"; }
warn() { echo -e "${YELLOW}WARN:${NC} $1"; }
err()  { echo -e "${RED}ERROR:${NC} $1"; exit 1; }
step() { echo -e "\n${BLUE}---${NC} $1 ${BLUE}---${NC}"; }

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -f /etc/arch-release ]]; then
        echo "arch"
    elif [[ -f /etc/debian_version ]]; then
        echo "ubuntu"
    else
        err "Unsupported OS. Supports: macOS, Arch Linux, Ubuntu/Debian."
    fi
}

OS=$(detect_os)
log "Detected OS: $OS"

# ---- System dependencies ----
step "Installing system dependencies"

case $OS in
    macos)
        command -v brew &>/dev/null || err "Homebrew not found. Install from https://brew.sh"
        brew install neovim nodejs go python3 ripgrep fd git curl
        ;;
    arch)
        sudo pacman -Sy --noconfirm --needed \
            neovim nodejs npm go python python-pip python-virtualenv \
            ripgrep fd git curl
        ;;
    ubuntu)
        sudo apt-get update -qq
        sudo apt-get install -y \
            git curl ripgrep golang nodejs npm \
            python3 python3-pip python3-venv fd-find

        # apt neovim is usually too old — use snap
        if ! command -v nvim &>/dev/null; then
            sudo snap install nvim --classic
        fi

        # ubuntu calls it fdfind
        if ! command -v fd &>/dev/null && command -v fdfind &>/dev/null; then
            sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
        fi
        ;;
esac

# ---- npm global tools ----
step "Installing npm global tools"
npm install -g markdownlint-cli
log "markdownlint-cli installed"

# ---- Undo directory (required by set.lua) ----
step "Creating undo directory"
mkdir -p ~/.vim/undodir
log "~/.vim/undodir ready"

# ---- Debug adapters ----
mkdir -p ~/debug-adapters

# debugpy — python DAP
step "Installing debugpy"
if [[ ! -d ~/.virtualenvs/debugpy ]]; then
    mkdir -p ~/.virtualenvs
    python3 -m venv ~/.virtualenvs/debugpy
    ~/.virtualenvs/debugpy/bin/pip install --quiet debugpy
    log "debugpy installed at ~/.virtualenvs/debugpy"
else
    log "debugpy already present, skipping"
fi

# delve — go DAP
step "Installing delve"
go install github.com/go-delve/delve/cmd/dlv@latest
log "delve installed at $(go env GOPATH)/bin/dlv"

# vscode-firefox-debug — JS/TS browser DAP
step "Installing vscode-firefox-debug"
if [[ ! -d ~/debug-adapters/vscode-firefox-debug ]]; then
    git clone --depth=1 \
        https://github.com/firefox-devtools/vscode-firefox-debug.git \
        ~/debug-adapters/vscode-firefox-debug
    pushd ~/debug-adapters/vscode-firefox-debug > /dev/null
    npm install --silent
    npm run build --silent
    popd > /dev/null
    log "vscode-firefox-debug installed"
else
    log "vscode-firefox-debug already present, skipping"
fi

# js-debug (pwa-node) — JS/TS node DAP
step "Installing js-debug"
if [[ ! -d ~/debug-adapters/js-debug ]]; then
    git clone --depth=1 \
        https://github.com/microsoft/vscode-js-debug \
        ~/debug-adapters/js-debug
    pushd ~/debug-adapters/js-debug > /dev/null
    npm install --silent
    npm run compile --silent
    popd > /dev/null
    log "js-debug installed"
else
    log "js-debug already present, skipping"
fi

# ---- Clone config (if not already in place) ----
step "Setting up neovim config"
NVIM_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
if [[ ! -d "$NVIM_CONFIG/.git" ]]; then
    git clone git@github.com:cboin1996/nvim.git "$NVIM_CONFIG"
    log "Config cloned to $NVIM_CONFIG"
else
    log "Config already present at $NVIM_CONFIG, skipping clone"
fi

# ---- Bootstrap plugins ----
step "Bootstrapping neovim plugins (may take a minute)"
nvim --headless -c "Lazy sync" -c "qa" 2>&1 || true
log "Plugins installed"

# ---- Manual steps reminder ----
echo ""
warn "Manual steps required:"
warn ""
warn "1. Install a Nerd Font (required for icons):"
warn "     https://www.nerdfonts.com/  — recommended: Hack Nerd Font"
warn "   Then set it as your terminal font."
warn ""
warn "2. For LaTeX support (texlab / latexindent):"
case $OS in
    macos)  warn "     brew install --cask mactex" ;;
    arch)   warn "     sudo pacman -S texlive-most perl" ;;
    ubuntu) warn "     sudo apt install texlive texlive-latex-extra perl" ;;
esac
warn ""
warn "3. Go debugger: ensure $(go env GOPATH)/bin is in your PATH"
warn "     export PATH=\"\$PATH:\$(go env GOPATH)/bin\""
echo ""
log "Done. Open neovim and run :checkhealth to verify the setup."
