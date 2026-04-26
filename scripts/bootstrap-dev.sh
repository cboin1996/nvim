#!/usr/bin/env bash
# Install local dev tools needed to run `make lint` etc.
set -euo pipefail

GREEN='\033[0;32m'; NC='\033[0m'
log() { echo -e "${GREEN}==>${NC} $1"; }

# selene — Lua linter
if ! command -v selene &>/dev/null; then
    OS="$(uname -s)"
    case "$OS" in
        Linux)
            ASSET="selene-linux.zip"
            BIN_DIR="$HOME/.local/bin"
            mkdir -p "$BIN_DIR"
            curl -fsSL \
                "https://github.com/Kampfkarren/selene/releases/latest/download/$ASSET" \
                -o /tmp/selene.zip
            unzip -o /tmp/selene.zip selene -d "$BIN_DIR"
            chmod +x "$BIN_DIR/selene"
            ;;
        Darwin)
            command -v brew &>/dev/null || { echo "Install Homebrew first"; exit 1; }
            brew install selene
            ;;
        *)
            echo "Unsupported OS for bootstrap. Install selene manually: https://github.com/Kampfkarren/selene"
            exit 1
            ;;
    esac
    log "selene installed"
else
    log "selene already installed ($(selene --version))"
fi
