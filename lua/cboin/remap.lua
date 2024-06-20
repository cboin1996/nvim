vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "open netrw" })

-- allows moving of code like alt-arrow in vscode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move line up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "append below line current" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "jump half pgdown" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "jump half pgup" })
vim.keymap.set("n", "n", "nzzzv", { desc = "while searching, keep cursor in middle of buffer" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "while searching, keep cursor in middle of buffer" })
-- window resize
vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]], {desc="make the window bigger vertically"})
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]], {desc="make the window smaller vertically"})
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]], {desc="make the window bigger horizontally"})
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]], {desc="make the window smaller horizontally"})
-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "paste over highlighted word, keeping ref to pasted word" })

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "delete to void register in normal or visual mode" })

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {desc = "replace word under cursor via sed"})
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true }, {desc="chmox current file"})
