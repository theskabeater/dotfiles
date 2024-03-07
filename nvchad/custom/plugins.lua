local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {
	-- Disable NvChad plugins
	{
		"folke/which-key.nvim",
		enabled = false,
	},
	-- Overrides
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	{
		"nvim-telescope/telescope.nvim",
		opts = overrides.telescope,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			lsp_fallback = true,
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd" },
				css = { "prettierd" },
				scss = { "prettierd" },
				html = { "prettierd" },
				angular = { "prettierd" },
				typescript = { "eslint_d" },
			},
		},
	},
	-- My plugins
	{
		"mfussenegger/nvim-lint",
		ft = { "typescript", "javascript" },
	},
	{
		"joeveiga/ng.nvim",
	},
	{
		"tpope/vim-fugitive",
		cmd = "Git",
	},
	{
		"pmizio/typescript-tools.nvim",
		opts = { tsserver_path = "$HOME/.config/yarn/global/node_modules/typescript/lib/tsserver.js" },
		ft = { "typescript" },
	},
}

return plugins
