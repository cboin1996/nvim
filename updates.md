# Update Procedure

## When to update plugins

Whenever you update system packages, also update neovim plugins. Neovim itself is managed by the system package manager, and plugin updates often track neovim API changes — letting them drift causes breakage.

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

`lazy-lock.json` pins every plugin to a specific commit. Committing it after updates means any other machine can run `:Lazy restore` to get the exact same plugin versions.

---

## Known issues

### LuaSnip fails to update (submodule error)

**Symptom:**
```
You have local changes in .../LuaSnip: deps/jsregexp
```
or
```
fatal: ../../.git/modules/deps/jsregexp006 is not a Git repository
fatal: cannot restore the submodule index
```

**Cause:** LuaSnip uses `jsregexp` as a git submodule. A previous build or clean step can leave the submodule in a corrupted state that blocks updates.

**Fix:** Wipe and reinstall:
```bash
rm -rf ~/.local/share/nvim/lazy/LuaSnip
nvim --headless -c "Lazy install" -c "qa"
```

---

### Lazy update fails on startup with lspconfig error

**Symptom:** `Lazy update` errors immediately with something like:
```
The `require('lspconfig')` "framework" is deprecated
...tailwind-tools/lua/tailwind-tools/lsp.lua
```

**Cause:** A plugin is calling the deprecated nvim-lspconfig v3 API and crashing startup before Lazy can run. `tailwind-tools` was the culprit and has been removed, but any plugin that internally calls `require('lspconfig')` will trigger this on lspconfig v3+.

**Fix:** Identify which plugin is in the stack trace, remove or disable it in `lua/cboin/lazy/`, then re-run `Lazy update`.

---

### Treesitter highlighter crash after neovim update

**Symptom:**
```
Decoration provider "start" (ns=nvim.treesitter.highlighter):
attempt to call method 'range' (a nil value)
```

**Cause:** Neovim updated (via pacman/brew) and the new treesitter runtime ABI doesn't match the compiled parsers.

**Fix:**
```bash
nvim --headless -c "TSUpdate" -c "qa"
```

---

### Lazy UI shows conflicts after headless update

**Symptom:** Opening Lazy after a headless `Lazy update` shows conflicts or dirty state.

**Cause:** `lazy-lock.json` was updated on disk by the headless run but not committed, so Lazy sees uncommitted changes.

**Fix:** Commit `lazy-lock.json` as described in the update procedure above.
