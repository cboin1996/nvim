return {
    "mfussenegger/nvim-lint",
    event = {
        "BufReadPre",
        "BufNewFile",
    },
    config = function()
        local lint = require("lint")
        -- add any linters here that
        -- aren't already handled
        -- within the lsp config
        lint.linters_by_ft = {
            markdown = { "markdownlint" },
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint(nil, { ignore_errors = true })
            end
        })
        vim.keymap.set("n", "<Leader>vl", function()
            lint.try_lint(nil, { ignore_errors = true })
        end, { desc = "lint file" })
    end
}
