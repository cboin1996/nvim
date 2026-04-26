# Changelog

## [Unreleased]

### Tested against
- neovim `v0.12.1` (Arch Linux)

### Added
- `install.sh` — cross-platform setup for Arch, Ubuntu, macOS. Installs system deps, debug adapters (debugpy, delve, js-debug, vscode-firefox-debug), bootstraps lazy.nvim headlessly.
- CI pipeline: selene lint on every push, headless boot test + DAP adapter checks on main/PRs with lazy plugin cache.
- `Makefile` with `lint`, `boot`, `check-dap`, `check-lsp`, `dev-bootstrap` targets (runs identically locally and in CI).
- `updates.md` — documents the update procedure and known issues.
- `CHANGELOG.md` — this file, maps config versions to neovim versions.
- tailwindcss LSP via mason-lspconfig.

### Fixed
- Removed `tailwind-tools.nvim` — incompatible with nvim-lspconfig v3 (calls deprecated framework API, crashes startup).
- Treesitter markdown crash on nvim 0.12: `nvim-lint` diagnostic publish triggers highlighter nil-node bug. Workaround: stop treesitter for markdown filetype, fall back to vim regex highlighting.
- tailwindcss LSP ordering conflict with lsp-zero resolved by routing through mason-lspconfig instead of tailwind-tools server setup.
- LuaSnip jsregexp submodule corruption: documented fix in `updates.md`.

---

## v0.1.0 — Initial public shape

### Tested against
- neovim `v0.10.x`

### Included
- lazy.nvim plugin management
- LSP via lsp-zero + mason (pyright, gopls, ts_ls, lua_ls, rust_analyzer, tflint, marksman, texlab)
- DAP: debugpy (Python), delve (Go), js-debug + vscode-firefox-debug (JS/TS)
- neotest: Python, Go, Jest
- Formatters: black, isort, prettier, stylua, latexindent (conform.nvim)
- Linters: pylint, markdownlint (nvim-lint)
- Telescope, Harpoon, Fugitive, Gitsigns, Trouble, Which-key, Rose-pine
