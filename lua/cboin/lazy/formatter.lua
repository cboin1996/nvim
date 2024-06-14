return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                markdown = { "markdownlint" }
            },
        })


        vim.keymap.set({ "n", "v" }, "<Leader>vf", function()
            conform.format({
                lsp_fallback = true, async = false, timeout_ms = 500
            })
        end)
    end
}
