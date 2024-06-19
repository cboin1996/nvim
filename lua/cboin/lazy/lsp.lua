return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "VonHeikemen/lsp-zero.nvim"
    },

    config = function()
        local lsp_zero = require("lsp-zero")
        lsp_zero.on_attach(function(client, bufnr)
            local opts = { buffer = bufnr, remap = false }

            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end,
                { buffer = bufnr, remap = false, desc = "jump to definition" })
            vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end,
                { buffer = bufnr, remap = false, desc = "jump to declaration" })
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end,
                { buffer = bufnr, remap = false, desc = "hover" })
            vim.keymap.set("n", "<Leader>vws", function() vim.lsp.buf.workspace_symbol() end,
                { buffer = bufnr, remap = false, desc = "workspace symbol" })
            vim.keymap.set("n", "<Leader>vd", function() vim.diagnostic.open_float() end,
                { buffer = bufnr, remap = false, desc = "view diagnostic" })
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end,
                { buffer = bufnr, remap = false, desc = "next diagnostic" })
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end,
                { buffer = bufnr, remap = false, desc = "previous diagnostic" })
            vim.keymap.set("n", "<Leader>vca", function() vim.lsp.buf.code_action() end,
                { buffer = bufnr, remap = false, desc = "view code action" })
            vim.keymap.set("n", "<Leader>vrr", function() vim.lsp.buf.references() end,
                { buffer = bufnr, remap = false, desc = "view references" })
            vim.keymap.set("n", "<Leader>vrn", function() vim.lsp.buf.rename() end,
                { buffer = bufnr, remap = false, desc = "refactor" })
            vim.keymap.set("n", "<Leader>vh", function() vim.lsp.buf.signature_help() end,
                { buffer = bufnr, remap = false, desc = "view doc" })
        end)

        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",        -- lua
                "rust_analyzer", -- rust
                "gopls",         -- go
                "tsserver",      -- typescript
                "pyright",       -- python
                "tflint",        -- terraform
                "marksman"       -- markdown
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
