# nvim

Personal Neovim configuration. Lua-based, plugin-managed via [lazy.nvim](https://github.com/folke/lazy.nvim). LSPs, formatters, and linters managed via [mason.nvim](https://github.com/williamboman/mason.nvim).

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/cboin1996/nvim/main/install.sh | bash
```

Or clone first and run locally:

```bash
git clone git@github.com:cboin1996/nvim.git ~/.config/nvim
bash ~/.config/nvim/install.sh
```

Supports **Arch Linux**, **Ubuntu/Debian**, and **macOS**.

## What the install script does

1. Installs system packages (neovim, node, go, python, ripgrep, fd, git)
2. Installs `markdownlint-cli` globally via npm
3. Creates `~/.vim/undodir` (required for persistent undo)
4. Installs debug adapters:
   - `~/.virtualenvs/debugpy/` — Python DAP (debugpy)
   - `~/debug-adapters/js-debug/` — JS/TS node DAP (pwa-node)
   - `~/debug-adapters/vscode-firefox-debug/` — JS/TS browser DAP
   - `dlv` via `go install` — Go DAP (delve)
5. Clones this repo to `~/.config/nvim` if not already there
6. Runs `nvim --headless` to bootstrap lazy.nvim and install all plugins

### Manual steps (post-install)

- **Nerd Font** — install [Hack Nerd Font](https://www.nerdfonts.com/) and set it in your terminal
- **Go PATH** — ensure `$(go env GOPATH)/bin` is in your `$PATH` for delve:

  ```bash
  export PATH="$PATH:$(go env GOPATH)/bin"
  ```

- **LaTeX** — install a TeX distribution for texlab/latexindent:
  - Arch: `sudo pacman -S texlive-most perl`
  - Ubuntu: `sudo apt install texlive texlive-latex-extra perl`
  - macOS: `brew install --cask mactex`

---

## Structure

```text
init.lua                    entrypoint — loads lua/cboin
lua/cboin/
  init.lua                  loads remap, set, lazy_init
  remap.lua                 global keymaps (leader, navigation, clipboard, tmux)
  set.lua                   vim options (tabs, undo, scroll, columns)
  lazy_init.lua             bootstraps lazy.nvim, loads lua/cboin/lazy/*.lua
  lazy/
    init.lua                plenary.nvim (shared utility dep)
    lsp.lua                 LSP, completion, mason, fidget
    dap.lua                 debugger (nvim-dap + language adapters + UI)
    testing.lua             neotest + language adapters
    treesitter.lua          syntax highlighting + text objects
    formatter.lua           conform.nvim (format on demand / format on save)
    lint.lua                nvim-lint (lint on save / insert leave)
    telescope.lua           fuzzy finder (files, grep, git, help)
    harpoon.lua             per-project file bookmarks
    fugitive.lua            git operations (status, push, pull, merge)
    gitsigns.lua            inline git hunks and blame
    trouble.lua             project-wide diagnostics panel
    whichkey.lua            keybinding hint popup
    colors.lua              rose-pine colorscheme + transparency
    colorpick.lua           ccc.nvim — inline color picker
    undotree.lua            visual persistent undo history
    previewers.lua          telescope bat-based file previewer
```

---

## Plugin Choices

### Plugin Manager — [lazy.nvim](https://github.com/folke/lazy.nvim)

Loads plugins lazily (on event, filetype, or command). Manages lockfile (`lazy-lock.json`) for reproducible installs across machines. Provides a UI (`:Lazy`) for updates, installs, and profiling. Chosen over packer.nvim (unmaintained) and vim-plug (no lazy loading).

### LSP — [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [lsp-zero](https://github.com/VonHeikemen/lsp-zero.nvim)

`nvim-lspconfig` is the official plugin for configuring neovim's built-in LSP client. `lsp-zero` removes boilerplate: it wires up `on_attach` keymaps and default handlers so you don't repeat the same 30 lines per language. Requires neovim 0.11+.

### LSP Server Management — [mason.nvim](https://github.com/williamboman/mason.nvim) + [mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim) + [mason-tool-installer](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim)

`mason` is a package manager for LSP servers, formatters, and linters — it installs binaries into `~/.local/share/nvim/mason/`. `mason-lspconfig` bridges mason and nvim-lspconfig so that `ensure_installed` servers are auto-configured. `mason-tool-installer` handles formatters and linters (tools that aren't LSP servers).

### Completion — [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)

Completion engine that aggregates sources: LSP (`cmp-nvim-lsp`), buffer words (`cmp-buffer`), file paths (`cmp-path`), and snippets (`cmp_luasnip`). Chosen for its modular source system and wide adoption.

### Snippets — [LuaSnip](https://github.com/L3MON4D3/LuaSnip)

Snippet engine integrated with nvim-cmp. Supports both LuaSnip format and VS Code format snippets. Required by many LSP servers for things like `$0` cursor placement after completion.

### LSP Progress — [fidget.nvim](https://github.com/j-hui/fidget.nvim)

Shows LSP server startup progress in the bottom-right corner. Useful for knowing when a large project's indexing (e.g. rust-analyzer) has finished.

### Syntax Highlighting — [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

Treesitter provides accurate, incremental syntax highlighting by parsing source code into an AST. Far more accurate than regex-based vim syntax files. Also enables structural text objects and indentation. Parsers are compiled `.so` files and must match neovim's ABI (see `updates.md` for how to handle parser rebuilds after neovim upgrades).

### Fuzzy Finder — [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

Fuzzy finder for files, grep, git files, help tags, and more. Uses ripgrep (`rg`) for grep and `fd` for file discovery. Extensible via pickers — most plugins (trouble, dap, etc.) provide their own telescope integration.

### File Navigation — [harpoon](https://github.com/ThePrimeagen/harpoon)

Per-project file bookmark list. Mark up to 4 files and jump to them instantly with `<C-h/j/k/l>`. Much faster than telescope for the 2–4 files you're actively editing in a session.

### Git — [vim-fugitive](https://github.com/tpope/vim-fugitive) + [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)

`fugitive` is the gold standard for git operations inside neovim: status pane, commit, push/pull, and a 3-way merge conflict editor. `gitsigns` adds inline hunk indicators in the sign column and per-hunk stage/reset/blame without leaving the buffer.

### Diagnostics — [trouble.nvim](https://github.com/folke/trouble.nvim)

Project-wide diagnostics panel — shows all LSP errors and warnings in a navigable list. Useful when you want to see everything broken at once rather than jumping through `[d`/`]d`.

### Keybinding Hints — [which-key.nvim](https://github.com/folke/which-key.nvim)

Shows a popup after pressing leader (or any prefix) listing available continuations. Eliminates the need to memorise every binding — press `<Space>` and wait 300ms to browse.

### Formatting — [conform.nvim](https://github.com/stevearc/conform.nvim)

Formatting engine that runs external formatters (prettier, black, stylua, etc.) and applies diffs back to the buffer. Chosen over null-ls (archived) and `vim.lsp.buf.format` because it handles multiple formatters per filetype, is fast, and doesn't require an LSP server.

### Linting — [nvim-lint](https://github.com/mfussenegger/nvim-lint)

Async linter runner. Triggers linters (pylint, markdownlint, selene) on `BufWritePost` and `InsertLeave` and pushes results to `vim.diagnostic`. Separate from LSP diagnostics — handles linters that don't speak LSP.

### Debugging — [nvim-dap](https://github.com/mfussenegger/nvim-dap) + adapters + [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)

`nvim-dap` implements the Debug Adapter Protocol (DAP) — the same protocol VS Code uses. Language-specific adapters bridge neovim and the actual debugger process. `nvim-dap-ui` provides the VS Code-style panels (variables, watch, call stack, breakpoints). Adapters:

- **debugpy** — Python, installed in `~/.virtualenvs/debugpy`
- **delve** — Go, installed via `go install`
- **js-debug** — Node.js, installed from GitHub release tarball
- **vscode-firefox-debug** — Firefox browser, built from source

### Testing — [neotest](https://github.com/nvim-neotest/neotest) + adapters

Test runner framework that integrates with the existing DAP setup for debugging tests. Provides a summary panel and inline pass/fail indicators. Adapters:

- **neotest-python** — pytest
- **neotest-go** — go test
- **neotest-jest** — Jest (TypeScript/JavaScript)

### Colorscheme — [rose-pine](https://github.com/rose-pine/neovim)

Warm, muted palette. Configured with transparent background so it inherits the terminal's background color.

### Color Picker — [ccc.nvim](https://github.com/uga-rosa/ccc.nvim)

Inline color picker and highlighter. Highlights hex/rgb/hsl values in the buffer and lets you open a picker to modify them. Useful when working with CSS or theme files.

### Undo Tree — [undotree](https://github.com/mbbill/undotree)

Visualises neovim's branching undo history as a tree. Neovim keeps a full undo history (persisted to `~/.vim/undodir`) including branches when you undo and then type something new — undotree makes this navigable.

---

## Languages

| Language   | LSP            | Formatter        | Linter       | DAP                       | Test           |
|------------|----------------|------------------|--------------|---------------------------|----------------|
| Python     | pyright        | black, isort     | pylint       | debugpy                   | neotest-python |
| Go         | gopls          | —                | —            | delve                     | neotest-go     |
| TypeScript | ts_ls          | prettier         | —            | js-debug, firefox-debug   | neotest-jest   |
| JavaScript | ts_ls          | prettier         | —            | js-debug, firefox-debug   | neotest-jest   |
| Lua        | lua_ls         | stylua           | selene       | —                         | —              |
| Rust       | rust_analyzer  | —                | —            | —                         | —              |
| Markdown   | marksman       | prettier         | markdownlint | —                         | —              |
| LaTeX      | texlab         | latexindent      | —            | —                         | —              |
| Terraform  | tflint         | —                | —            | —                         | —              |
| Tailwind   | tailwindcss    | —                | —            | —                         | —              |
| Java       | jdtls          | —                | —            | —                         | —              |

LSP servers and formatters are auto-installed by mason on first launch. Exception: `texlab`/`latexindent` require a TeX distribution installed separately (see post-install steps above).

---

## Adding a New Language

1. **LSP** — add the server name to `ensure_installed` in `lua/cboin/lazy/lsp.lua`:

   ```lua
   require("mason-lspconfig").setup({
       ensure_installed = {
           "your_lsp_server",  -- add here
       },
   })
   ```

   Find the correct server name at [mason-lspconfig server list](https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers).

2. **Formatter** — add to `mason-tool-installer` in `lsp.lua` and configure in `lua/cboin/lazy/formatter.lua`:

   ```lua
   -- lsp.lua
   require("mason-tool-installer").setup({
       ensure_installed = { "your-formatter" },
   })

   -- formatter.lua (conform.nvim formatters_by_ft)
   yourlang = { "your-formatter" },
   ```

3. **Linter** — add to `mason-tool-installer` in `lsp.lua` and configure in `lua/cboin/lazy/lint.lua`:

   ```lua
   -- lsp.lua
   require("mason-tool-installer").setup({
       ensure_installed = { "your-linter" },
   })

   -- lint.lua (linters_by_ft)
   yourlang = { "your-linter" },
   ```

4. **Treesitter** — add the parser name to `ensure_installed` in `lua/cboin/lazy/treesitter.lua`:

   ```lua
   ensure_installed = { "your_language" },
   ```

5. **DAP** — add adapter config to `lua/cboin/lazy/dap.lua`. See the [nvim-dap wiki](https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation) for adapter-specific setup. Update `install.sh` and `scripts/check-dap.sh` if the adapter needs a binary installed.

6. **Testing** — add the neotest adapter plugin and configure it in `lua/cboin/lazy/testing.lua`.

---

## Key Mappings

Leader key: `<Space>`

### Navigation

| Key | Action |
|-----|--------|
| `<leader>pv` | Open netrw |
| `<leader>pf` | Find files (telescope) |
| `<C-p>` | Find git files (telescope) |
| `<leader>ps` | Grep search |
| `<leader>pws` | Grep word under cursor |
| `<leader>pWs` | Grep WORD under cursor |
| `<leader>ph` | Help tags |
| `<C-d>` / `<C-u>` | Half page down/up (cursor centered) |
| `n` / `N` | Search next/prev (cursor centered) |

### Harpoon

| Key | Action |
|-----|--------|
| `<leader>a` | Add file to harpoon |
| `<C-e>` | Toggle harpoon menu |
| `<C-h/j/k/l>` | Jump to harpoon file 1–4 |

### LSP (active in LSP buffers)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `K` | Hover docs |
| `<leader>vca` | Code actions |
| `<leader>vrr` | References |
| `<leader>vrn` | Rename symbol |
| `<leader>vh` | Signature help |
| `<leader>vd` | Open diagnostic float |
| `[d` / `]d` | Next/prev diagnostic |
| `<leader>vws` | Workspace symbol search |
| `<leader>vf` | Format file/selection |
| `<leader>vl` | Lint file |

### Debugging (DAP)

| Key | Action |
|-----|--------|
| `<leader>dc` | Continue |
| `<leader>db` | Toggle breakpoint |
| `<leader>dn` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dr` | Restart |
| `<leader>de` | Terminate |
| `<leader>dC` | Clear breakpoints |
| `<leader>dl` | Hover value |

### Testing (neotest)

| Key | Action |
|-----|--------|
| `<leader>nr` | Run nearest test |
| `<leader>nR` | Run all tests in file |
| `<leader>nd` | Debug nearest test |
| `<leader>ns` | Stop test |
| `<leader>no` | Open test output |
| `<leader>nO` | Open test output (enter buffer) |
| `<leader>nt` | Toggle test summary |

### Git

| Key | Action |
|-----|--------|
| `<leader>gs` | Git status (fugitive) |
| `gmc` | Merge conflict editor |
| `gu` / `gh` | Keep local / keep remote (merge) |
| `]c` / `[c` | Next/prev git hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hb` | Blame line |
| `<leader>hd` | Diff this |
| `<leader>hD` | Diff against last commit |

### Trouble

| Key | Action |
|-----|--------|
| `<leader>tt` | Toggle diagnostics panel |
| `[t` / `]t` | Next/prev diagnostic (trouble) |

### Window

| Key | Action |
|-----|--------|
| `=` / `-` | Resize vertical +5/-5 |
| `+` / `_` | Resize horizontal +2/-2 |
| `<leader>wds` | Enable diff on windows |
| `<leader>wde` | Disable diff on windows |

### Misc

| Key | Action |
|-----|--------|
| `<leader>y` | Yank to system clipboard |
| `<leader>p` (visual) | Paste without clobbering register |
| `<leader>s` | Replace word under cursor (project-wide) |
| `<leader>x` | chmod +x current file |
| `<leader>f` | Open tmux sessionizer |
| `<leader>lw` | Set local buffer tab width |
| `J` / `K` (visual) | Move selected lines down/up |

---

## CI

Every pull request runs:

| Check | What it does |
|-------|-------------|
| **selene** | Lints all Lua in `lua/` with [selene](https://github.com/Kampfkarren/selene) |
| **headless boot** | Boots neovim headlessly (`nvim --headless -c "qa"`) and fails on unexpected output |
| **DAP adapters** | Verifies all debug adapter binaries are present and executable |

Run locally with:

```bash
make lint   # selene
make boot   # headless boot
make check-dap  # DAP adapter check
make        # all three
```
