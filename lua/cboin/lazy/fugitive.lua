return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "open git status pane" })

        local fug = vim.api.nvim_create_augroup("cboin", {})

        local autocmd = vim.api.nvim_create_autocmd
        autocmd("BufWinEnter", {
            group = fug,
            pattern = "*",
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end
                local bufnr = vim.api.nvim_get_current_buf()
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    opts.remap = false
                    vim.keymap.set(mode, l, r, opts)
                end

                map("n", "<leader>p", function()
                    vim.cmd.Git('push')
                end, { desc = "git push" })
                -- rebase always
                map("n", "<leader>P", function()
                    vim.cmd.Git('pull --rebase')
                end, { desc = "git pull" })
                -- NOTE: It allows me to easily set the branch i am pushing and any tracking
                -- needed if i did not set the branch up correctly
                map("n", "<leader>t", ":Git push -u origin ", { desc = "git push (set branch)" });
            end,
        })
        vim.keymap.set("n", "gmc", "<cmd>Gvdiffsplit!<CR>", { desc = "open merge conflict editor" })
        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>", { desc = "keep local" })
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>", { desc = "keep remote" })
    end
}
