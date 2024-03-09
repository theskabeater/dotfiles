local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {
	-- Disable NvChad plugins
	{
		"folke/which-key.nvim",
		enabled = false,
	},
	{
		"NvChad/nvim-colorizer.lua",
		enabled = false,
	},
	{
		"windwp/nvim-autopairs",
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
		"NvChad/nvterm",
		opts = overrides.nvterm,
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
				typescript = { "prettierd" },
			},
		},
	},
	-- My plugins
	{
		"numToStr/Comment.nvim",
		dependencies = {
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				config = function()
					vim.g.skip_ts_context_commentstring_module = true
					require("ts_context_commentstring").setup({
						languages = {
							angular = "<!-- %s -->",
						},
					})
					require("Comment").setup({
						pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
					})
				end,
			},
		},
	},
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
