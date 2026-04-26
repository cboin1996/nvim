# nvim

Personal Neovim configuration. Lua-based, plugin-managed via [lazy.nvim](https://github.com/folke/lazy.nvim). LSPs and formatters managed via [mason.nvim](https://github.com/williamboman/mason.nvim).

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/cboin1996/nvim/main/install.sh | bash
```

Or clone first and run locally:

```bash
git clone git@github.com:cboin1996/nvim.git ~/.config/nvim
~/.config/nvim/install.sh
```

Supports **Arch Linux**, **Ubuntu/Debian**, and **macOS**.

## What the install script does

1. Installs system packages (neovim, node, go, python, ripgrep, fd, git)
2. Installs `markdownlint-cli` globally via npm
3. Creates `~/.vim/undodir` (required for persistent undo)
4. Installs debug adapters:
   - `~/.virtualenvs/debugpy/` — Python DAP (debugpy)
   - `~/debug-adapters/vscode-firefox-debug/` — JS/TS browser DAP
   - `~/debug-adapters/js-debug/` — JS/TS node DAP (pwa-node)
   - `dlv` via `go install` — Go DAP (delve)
5. Clones this repo to `~/.config/nvim` if not already there
6. Runs `nvim --headless` to bootstrap lazy.nvim and install all plugins

### Manual steps (post-install)

- **Nerd Font** — install [Hack Nerd Font](https://www.nerdfonts.com/) and set it in your terminal
- **LaTeX** — install a TeX distribution for texlab/latexindent to work:
  - Arch: `sudo pacman -S texlive-most perl`
  - Ubuntu: `sudo apt install texlive texlive-latex-extra perl`
  - macOS: `brew install --cask mactex`
- **Go PATH** — ensure `$(go env GOPATH)/bin` is in your `$PATH` for delve

## Structure

```
init.lua                    entrypoint — loads lua/cboin
lua/cboin/
  init.lua                  loads remap, set, lazy_init
  remap.lua                 global keymaps
  set.lua                   vim options
  lazy_init.lua             bootstraps lazy.nvim, loads lua/cboin/lazy/*.lua
  lazy/
    init.lua                plenary (shared dep)
    lsp.lua                 LSP, mason, nvim-cmp, fidget
    dap.lua                 nvim-dap, dap-python, dap-go, dap-ui
    testing.lua             neotest + adapters (python, go, jest)
    treesitter.lua          tree-sitter parsers + highlighting
    formatter.lua           conform.nvim (format on demand)
    lint.lua                nvim-lint (lint on save/insert leave)
    telescope.lua           fuzzy finder
    harpoon.lua             file bookmarking
    fugitive.lua            git integration
    gitsigns.lua            inline git hunks + blame
    trouble.lua             diagnostics panel
    whichkey.lua            keybinding hints
    colors.lua              rose-pine colorscheme
    tailwind.lua            tailwind-tools + cmp integration
    colorpick.lua           color picker
    undotree.lua            persistent undo tree
    previewers.lua          telescope previewers
```

## Languages

| Language   | LSP           | Formatter       | Linter      | DAP                  | Test        |
|------------|---------------|-----------------|-------------|----------------------|-------------|
| Python     | pyright       | black, isort    | pylint      | debugpy              | neotest-python |
| Go         | gopls         | —               | —           | delve                | neotest-go  |
| TypeScript | ts_ls         | prettier        | —           | js-debug, firefox    | neotest-jest |
| JavaScript | ts_ls         | prettier        | —           | js-debug, firefox    | neotest-jest |
| Lua        | lua_ls        | stylua          | —           | —                    | —           |
| Rust       | rust_analyzer | —               | —           | —                    | —           |
| Markdown   | marksman      | prettier        | markdownlint | —                   | —           |
| LaTeX      | texlab        | latexindent     | —           | —                    | —           |
| Terraform  | tflint        | —               | —           | —                    | —           |
| Tailwind   | tailwindcss   | —               | —           | —                    | —           |

LSPs, formatters, and linters are auto-installed by mason on first launch (except texlab/latexindent which require a TeX distribution).

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

### Trouble

| Key | Action |
|-----|--------|
| `<leader>tt` | Toggle diagnostics panel |
| `[t` / `]t` | Next/prev diagnostic |

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
