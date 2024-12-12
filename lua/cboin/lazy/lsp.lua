return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
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
            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                opts.remap = false
                vim.keymap.set(mode, l, r, opts)
            end
            map("n", "gd", function() vim.lsp.buf.definition() end,
                { desc = "jump to definition" })
            map("n", "gD", function() vim.lsp.buf.declaration() end,
                { desc = "jump to declaration" })
            map("n", "K", function() vim.lsp.buf.hover() end,
                { desc = "hover" })
            map("n", "<Leader>vws", function() vim.lsp.buf.workspace_symbol() end,
                { desc = "workspace symbol" })
            map("n", "<Leader>vd", function() vim.diagnostic.open_float() end,
                { desc = "view diagnostic" })
            map("n", "[d", function() vim.diagnostic.goto_next() end,
                { desc = "next diagnostic" })
            map("n", "]d", function() vim.diagnostic.goto_prev() end,
                { desc = "previous diagnostic" })
            map("n", "<Leader>vca", function() vim.lsp.buf.code_action() end,
                { desc = "view code action" })
            map("n", "<Leader>vrr", function() vim.lsp.buf.references() end,
                { desc = "view references" })
            map("n", "<Leader>vrn", function() vim.lsp.buf.rename() end,
                { desc = "refactor" })
            map("n", "<Leader>vh", function() vim.lsp.buf.signature_help() end,
                { desc = "view doc" })
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
                "ts_ls",         -- typescript
                "pyright",       -- python
                "tflint",        -- terraform
                "marksman",      -- markdown
                "texlab",        -- latex
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
        require("mason-tool-installer").setup({
            ensure_installed = {
                "prettier",
                "stylua",
                "black",
                "isort",
                "pylint",
                "latexindent", -- latex
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
