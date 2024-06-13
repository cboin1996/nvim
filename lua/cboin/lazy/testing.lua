return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-python"
    },
    config = function ()
        -- setup python
        require("neotest").setup({
              adapters = {
                    require("neotest-python")({
                        pytest_discover_instances = true,
                    })
              },
        })
	local nt = require("neotest")
	vim.keymap.set("n", "<Leader>nd", function() nt.run.run({strategy="dap"}) end)
	vim.keymap.set("n", "<Leader>nr", function() nt.run.run() end)
	vim.keymap.set("n", "<Leader>nR", function() nt.run.run(vim.fn.expand("%")) end)
	vim.keymap.set("n", "<Leader>ns", function() nt.run.stop() end)
	vim.keymap.set("n", "<Leader>no", function() nt.output.open() end)
	vim.keymap.set("n", "<Leader>nO", function() nt.output.open({enter = true}) end)
	vim.keymap.set("n", "<Leader>nt", function() nt.summary.toggle() end)
    end
}
