local plugins = {
	"nvim-lua/plenary.nvim",

	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		config = function()
			require("plugins.configs.gruvbox")
		end,
	},

	{
		"tpope/vim-commentary",
		"tpope/vim-repeat",
		"tpope/vim-sleuth",
		"tpope/vim-surround",
		lazy = false,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufEnter" },
		build = ":TSUpdate",
		opts = function()
			return require("plugins.configs.treesitter")
		end,
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		ft = { "typescript" },
		opts = function()
			return require("plugins.configs.others").ts_context_commentstring
		end,
		config = function(_, opts)
			require("ts_context_commentstring").setup(opts)
		end,
	},

	{
		"neovim/nvim-lspconfig",
		ft = { "angular", "lua", "typescript" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall" },
		dependencies = {
			{
				"williamboman/mason.nvim",
				dependencies = { "williamboman/mason-lspconfig.nvim" },
				opts = function()
					return require("plugins.configs.mason")
				end,
				config = function(_, opts)
					require("mason").setup()
					require("mason-lspconfig").setup(opts)
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter" },
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				opts = { history = true, updateevents = "TextChanged,TextChangedI" },
				config = function(_, opts)
					require("plugins.configs.others").luasnip(opts)
				end,
			},
			{
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
			},
		},
		opts = function()
			return require("plugins.configs.cmp")
		end,
		config = function(_, opts)
			require("cmp").setup(opts)
		end,
	},

	{
		"mfussenegger/nvim-lint",
		ft = { "javascript", "typescript" },
		config = function()
			return require("plugins.configs.nvimlint")
		end,
	},

	{
		"stevearc/conform.nvim",
		keys = {
			{ "<leader>j", '<CMD>lua require("conform").format({ async = true, lsp_fallback = true})<CR>' },
		},
		opts = function()
			return require("plugins.configs.conform")
		end,
		config = function(_, opts)
			require("conform").setup(opts)
		end,
	},

	{
		"pmizio/typescript-tools.nvim",
		ft = { "javascript", "typescript" },
		config = function()
			require("typescript-tools").setup({})
		end,
	},

	{
		"joeveiga/ng.nvim",
		keys = {
			{ "<leader>ac", "<CMD>lua require('ng').goto_component_with_template_file()<CR>" },
			{ "<leader>at", "<CMD>lua require('ng').goto_template_for_component()<CR>" },
			{ "<leader>aT", "<CMD>lua require('ng').ng.get_template_tcb()<CR>" },
		},
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter" },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
			{ "nvim-tree/nvim-web-devicons" },
		},
		cmd = "Telescope",
		keys = {
			{ "<leader>fc", "<CMD>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>" },
			{ "<leader>fb", "<CMD>lua require('telescope.builtin').buffers()<CR>" },
			{ "<leader>fd", "<CMD>lua require('telescope.builtin').diagnostics()<CR>" },
			{ "<leader>ff", "<CMD>lua require('telescope.builtin').live_grep()<CR>" },
			{ "<leader>fh", "<CMD>lua require('telescope.builtin').help_tags()<CR>" },
			{ "<leader>fo", "<CMD>lua require('telescope.builtin').oldfiles()<CR>" },
			{ "<leader>fp", "<CMD>lua require('telescope.builtin').find_files()<CR>" },
			{ "<leader>fr", "<CMD>lua require('telescope.builtin').lsp_references()<CR>" },
			{
				"<leader>fw",
				"<CMD>lua require('telescope.builtin').grep_string({default_text = vim.fn.expand('<cword>')})<CR>",
				"n",
			},
		},
		opts = function()
			return require("plugins.configs.telescope")
		end,
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)

			for _, ext in ipairs(opts.extensions_list) do
				telescope.load_extension(ext)
			end
		end,
	},

	{
		"stevearc/oil.nvim",
		keys = { { "-", "<CMD>Oil<CR>" } },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = function()
			return require("plugins.configs.oil")
		end,
		config = function(_, opts)
			require("oil").setup(opts)
		end,
	},

	{
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>gs", "<CMD>Git<CR>", "n" },
			{ "<leader>gb", "<CMD>Git blame<CR>", "n" },
		},
		cmd = "Git",
	},

	{
		"lewis6991/gitsigns.nvim",
		cond = function()
			return vim.fs.find(".git", { upward = true })[1] and true or false
		end,
		opts = function()
			return require("plugins.configs.others").gitsigns
		end,
		config = function(_, opts)
			require("gitsigns").setup(opts)
		end,
	},
}
require("lazy").setup(plugins)
