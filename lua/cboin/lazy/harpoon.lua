return {
    "theprimeagen/harpoon",
    config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")
        vim.keymap.set("n", "<leader>a", mark.add_file, {desc="append to harpoon"})
        vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, {desc="toggle harpoon"})
        vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end, {desc="open harpoon file 1"})
        vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end, {desc="open harpoon file 2"})
        vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end, {desc="open harpoon file 3"})
        vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end, {desc="open harpoon file 4"})
    end
}
