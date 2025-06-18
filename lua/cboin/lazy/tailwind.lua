-- tailwind-tools.lua
return {
	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim", -- optional
			"neovim/nvim-lspconfig", -- optional
		},
		opts = {}, -- your configuration
	},
	-- nvim-cmp.lua
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"tailwind-tools",
			"onsails/lspkind-nvim",
			-- ...
		},
		opts = function()
			return {
				-- ...
				formatting = {
					format = require("lspkind").cmp_format({
						before = require("tailwind-tools.cmp").lspkind_format,
					}),
				},
			}
		end,
	},
}
