return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require('gitsigns').setup {
            on_attach = function(bufnr)
                local gitsigns = require('gitsigns')

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map('n', ']c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ ']c', bang = true })
                    else
                        gitsigns.nav_hunk('next')
                    end
                end, {desc="next git hunk"})

                map('n', '[c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ '[c', bang = true })
                    else
                        gitsigns.nav_hunk('prev')
                    end
                end, {desc="previous git hunk"})

                -- Actions
                map('n', '<leader>hs', gitsigns.stage_hunk, {desc="stage hunk"})
                map('n', '<leader>hr', gitsigns.reset_hunk, {desc="reset hunk"})
                map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, {desc="stage highlighted hunk"})
                map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, {desc="reset highlighted hunk"})
                map('n', '<leader>hS', gitsigns.stage_buffer, {desc="stage buffer"})
                map('n', '<leader>hu', gitsigns.undo_stage_hunk, {desc="undo stage hunk"})
                map('n', '<leader>hR', gitsigns.reset_buffer, {desc="reset buffer"})
                map('n', '<leader>hp', gitsigns.preview_hunk_inline, {desc="preview hunk"})
                map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, {desc="blame line"})
                map('n', '<leader>htb', gitsigns.toggle_current_line_blame, {desc="toggle current line blame"})
                map('n', '<leader>hd', gitsigns.diffthis, {desc="show diff"})
                map('n', '<leader>hD', function() gitsigns.diffthis('~') end, {desc="show diff"})
                map('n', '<leader>htd', gitsigns.toggle_deleted, {desc="toggle deleted"})

                -- Text object
                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {desc="select hunk"})
            end
        }
    end
}
