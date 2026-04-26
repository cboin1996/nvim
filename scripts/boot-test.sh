#!/usr/bin/env bash
set -euo pipefail

echo "Running neovim headless boot test..."

OUTPUT=$(nvim --headless -c "qa" 2>&1 || true)

# Filter known benign output that we can't control (lsp-zero internals)
FILTERED=$(echo "$OUTPUT" | grep -v \
    -e "vim.tbl_flatten is deprecated" \
    -e 'Run ":checkhealth vim.deprecated"' \
    -e "^[[:space:]]*$" \
    || true)

if [[ -n "$FILTERED" ]]; then
    echo "FAIL: Unexpected output during boot:"
    echo "$FILTERED"
    exit 1
fi

echo "PASS: neovim booted cleanly"
