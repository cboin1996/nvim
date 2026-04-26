#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0

check() {
    local name="$1"; shift
    if "$@" &>/dev/null; then
        echo "  PASS: $name"
        ((PASS++))
    else
        echo "  FAIL: $name"
        ((FAIL++))
    fi
}

check_file() {
    local name="$1"
    local path="$2"
    if [[ -f "$path" ]]; then
        echo "  PASS: $name ($path)"
        ((PASS++))
    else
        echo "  FAIL: $name — not found at $path"
        ((FAIL++))
    fi
}

echo "Checking debug adapters..."

# Python — debugpy
check "debugpy" \
    "$HOME/.virtualenvs/debugpy/bin/python" -m debugpy --version

# Go — delve
check "delve" \
    dlv version

# JS/TS — js-debug (pwa-node)
check_file "js-debug adapter" \
    "$HOME/debug-adapters/js-debug/src/dapDebugServer.js"

check "js-debug (node runs it)" \
    node "$HOME/debug-adapters/js-debug/src/dapDebugServer.js" --help

# JS/TS — vscode-firefox-debug
check_file "vscode-firefox-debug adapter" \
    "$HOME/debug-adapters/vscode-firefox-debug/dist/adapter.bundle.js"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
