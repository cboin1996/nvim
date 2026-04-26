#!/usr/bin/env bash
# Checks that mason-installed LSP binaries exist.
# Run locally after first neovim boot (mason auto-installs on startup).
set -euo pipefail

MASON_BIN="$HOME/.local/share/nvim/mason/bin"
PASS=0
FAIL=0

check_bin() {
    local name="$1"
    local bin="${2:-$1}"
    if [[ -x "$MASON_BIN/$bin" ]]; then
        echo "  PASS: $name"
        ((PASS++))
    else
        echo "  FAIL: $name — not found at $MASON_BIN/$bin"
        ((FAIL++))
    fi
}

echo "Checking mason LSP binaries ($MASON_BIN)..."

check_bin "pyright"                   "pyright-langserver"
check_bin "gopls"
check_bin "lua-language-server"
check_bin "rust-analyzer"
check_bin "typescript-language-server" "typescript-language-server"
check_bin "tflint"
check_bin "marksman"
check_bin "texlab"
check_bin "tailwindcss-language-server"

echo ""
echo "Checking mason formatter/linter binaries..."

check_bin "prettier"
check_bin "stylua"
check_bin "black"
check_bin "isort"
check_bin "pylint"

echo ""
echo "Results: $PASS passed, $FAIL failed"
echo "(Run ':MasonInstall <name>' inside neovim to install any missing ones)"
[[ $FAIL -eq 0 ]]
