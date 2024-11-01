return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-python",
        "nvim-neotest/neotest-go"
    },
    config = function()
        -- setup python
        require("neotest").setup({
            adapters = {
                require("neotest-python")({
                    pytest_discover_instances = true,
                    dap = { justMyCode = false },
                }),
                require("neotest-go"),
            },
        })
        local nt = require("neotest")
        vim.keymap.set("n", "<Leader>nd", function() nt.run.run({ strategy = "dap" }) end, { desc = "debug test" })
        vim.keymap.set("n", "<Leader>nr", function() nt.run.run() end, { desc = "run test" })
        vim.keymap.set("n", "<Leader>nR", function() nt.run.run(vim.fn.expand("%")) end, { desc = "run test at cursor" })
        vim.keymap.set("n", "<Leader>ns", function() nt.run.stop() end, { desc = "stop test" })
        vim.keymap.set("n", "<Leader>no", function() nt.output.open() end, { desc = "open test result" })
        vim.keymap.set("n", "<Leader>nO", function() nt.output.open({ enter = true }) end,
            { desc = "open (and enter buffer) test result" })
        vim.keymap.set("n", "<Leader>nt", function() nt.summary.toggle() end, { desc = "toggle test summary" })
    end
}
