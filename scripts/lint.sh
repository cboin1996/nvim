#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

command -v selene &>/dev/null || {
    echo "selene not found. Run: scripts/bootstrap-dev.sh"
    exit 1
}

echo "Running selene..."
selene --config "$REPO_ROOT/selene.toml" "$REPO_ROOT/lua"
echo "PASS: lint clean"
