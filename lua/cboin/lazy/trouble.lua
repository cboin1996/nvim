return {
    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup()

            vim.keymap.set("n", "<Leader>tt", function()
                require("trouble").toggle({mode="diagnostics"}, {desc="toggle trouble diagnostics summary"})
            end)

            vim.keymap.set("n", "[t", function()
                require("trouble").next({skip_groups = true, jump = true}, {desc="next trouble diagnostic"});
            end)

            vim.keymap.set("n", "]t", function()
                require("trouble").prev({skip_groups = true, jump = true}, {desc="next trouble diagnostic"});
            end)

        end
    },
}
