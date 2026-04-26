return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            -- A list of parser names, or "all"
            ensure_installed = {
                "vimdoc", "javascript", "typescript", "c", "lua", "rust",
                "jsdoc", "bash", "python", "go", "terraform"
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
            auto_install = true,

            indent = {
                enable = true
            },

            highlight = {
                -- `false` will disable the whole extension
                enable = true,

                -- markdown treesitter highlight triggers a nil-node crash in nvim 0.12
                -- via the nvim-lint → diagnostic.set → redraw → highlighter chain.
                -- disable until upstream fixes it; regex highlighting covers markdown fine.
                disable = { "markdown", "markdown_inline" },

                additional_vim_regex_highlighting = { "markdown" },
            },
        })

        local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        treesitter_parser_config.templ = {
            install_info = {
                url = "https://github.com/vrischmann/tree-sitter-templ.git",
                files = {"src/parser.c", "src/scanner.c"},
                branch = "master",
            },
        }

        vim.treesitter.language.register("templ", "templ")

        -- markdown treesitter crashes in nvim 0.12 (nil node in highlighter via nvim-lint).
        -- stop treesitter entirely for markdown until upstream fixes it.
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "markdown" },
            callback = function() vim.treesitter.stop() end,
        })
    end
}
