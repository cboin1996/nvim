return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")
        -- any formatters here must be installed through
        -- mason, or externally
        conform.setup({
            formatters_by_ft = {
                python = { "isort", "black" },
                typescript = { "prettier" },
                lua = { "stylua" },
                markdown = { "prettier" }
            },
        })


        vim.keymap.set({ "n", "v" }, "<Leader>vf", function()
            conform.format({
                lsp_fallback = true, async = false, timeout_ms = 500
            })
        end, {desc="format file"})
    end
}
