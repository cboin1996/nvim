# Update Procedure

## When to update plugins

Whenever you update system packages, also update neovim plugins. Neovim itself
is managed by the system package manager, and plugin updates often track neovim
API changes — letting them drift causes breakage.

```bash
# Arch
sudo pacman -Syu

# macOS
brew upgrade
```

Then update plugins:

```bash
nvim --headless -c "Lazy update" -c "qa"
# or open neovim and press U in the Lazy UI
```

Then update treesitter parsers (recompiles them against the current neovim ABI):

```bash
nvim --headless -c "TSUpdate" -c "qa"
```

After a successful update, commit the lockfile:

```bash
git add lazy-lock.json
git commit -m "chore: update lazy-lock.json"
```

`lazy-lock.json` pins every plugin to a specific commit. Committing it after
updates means any other machine can run `:Lazy restore` to get the exact same
plugin versions.

---

## Known issues

### LuaSnip fails to update (submodule error)

**Symptom:**

```text
You have local changes in .../LuaSnip: deps/jsregexp
```

or

```text
fatal: ../../.git/modules/deps/jsregexp006 is not a Git repository
fatal: cannot restore the submodule index
```

**Cause:** LuaSnip uses `jsregexp` as a git submodule. A previous build or clean
step can leave the submodule in a corrupted state that blocks updates.

**Fix:** Wipe and reinstall:

```bash
rm -rf ~/.local/share/nvim/lazy/LuaSnip
nvim --headless -c "Lazy install" -c "qa"
```

---

### Lazy update fails on startup with lspconfig error

**Symptom:** `Lazy update` errors immediately with something like:

```text
The `require('lspconfig')` "framework" is deprecated
...tailwind-tools/lua/tailwind-tools/lsp.lua
```

**Cause:** A plugin is calling the deprecated nvim-lspconfig v3 API and crashing
startup before Lazy can run. `tailwind-tools` was the culprit and has been
removed, but any plugin that internally calls `require('lspconfig')` will
trigger this on lspconfig v3+.

**Fix:** Identify which plugin is in the stack trace, remove or disable it in
`lua/cboin/lazy/`, then re-run `Lazy update`.

---

### Treesitter highlighter crash after neovim update

**Symptom:**

```text
Decoration provider "start" (ns=nvim.treesitter.highlighter):
attempt to call method 'range' (a nil value)
```

Often triggered on a specific filetype (e.g. opening a `.md` file).

**Cause:** Neovim updated and the new treesitter ABI doesn't match the compiled
parser `.so` files. `TSUpdate` checks commit hashes only — it won't recompile a
parser that's already at the right commit but built against an old ABI.

**Fix — try TSUpdate first:**

```bash
nvim --headless -c "TSUpdate" -c "qa"
```

**If the error persists on a specific filetype, force-reinstall that parser:**

```bash
# example: markdown
nvim --headless -c "TSInstall! markdown markdown_inline" -c "qa"
```

**If errors are widespread after a major neovim version bump (e.g. 0.11 → 0.12),
reinstall all parsers:**

```bash
nvim --headless -c "TSUpdateSync" -c "qa"
```

**If the error persists after reinstalling (confirmed on nvim 0.12 +
markdown):**

The crash can be triggered by nvim-lint publishing diagnostics →
`vim.diagnostic.set` → redraw → treesitter highlighter hitting a nil node. This
is a neovim bug, not a parser issue. Reinstalling the parser won't help.

Workaround: stop treesitter entirely for the affected filetype. In
`lua/cboin/lazy/treesitter.lua`:

```lua
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    callback = function() vim.treesitter.stop() end,
})
```

Falls back to vim regex highlighting. Remove once neovim patches the
highlighter.

---

### debugpy venv broken after system Python upgrade

**Symptom:**

```text
ModuleNotFoundError: No module named 'pip'
# or
ModuleNotFoundError: No module named 'debugpy'
```

**Cause:** Arch and macOS update Python in place. The venv's `pip` and installed
packages point to the old Python version and stop working.

**Fix:** Recreate the venv:

```bash
rm -rf ~/.virtualenvs/debugpy
python3 -m venv ~/.virtualenvs/debugpy
~/.virtualenvs/debugpy/bin/pip install debugpy
```

---

### Lazy UI shows conflicts after headless update

**Symptom:** Opening Lazy after a headless `Lazy update` shows conflicts or
dirty state.

**Cause:** `lazy-lock.json` was updated on disk by the headless run but not
committed, so Lazy sees uncommitted changes.

**Fix:** Commit `lazy-lock.json` as described in the update procedure above.
