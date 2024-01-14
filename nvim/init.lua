-- non-plugin stuff
vim.g.mapleader = " "
vim.o.backup = false
vim.o.clipboard = "unnamedplus"
vim.o.expandtab = true
vim.o.diffopt = "vertical"
vim.o.ignorecase = true
vim.o.inccommand = "nosplit"
vim.o.incsearch = true
vim.o.iskeyword = vim.o.iskeyword .. ",@-@,$"
vim.o.mouse = "a"
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.showmode = false
vim.o.shiftwidth = 2
vim.o.smartcase = true
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.updatetime = 100
vim.o.writebackup = false
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"
vim.o.termguicolors = true

-- toggle search highlighting
vim.api.nvim_set_keymap("n", "<C-l>", "<CMD>noh<CR>", { noremap = true })

-- highlight yanks
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
	end,
})

-- trim trailing space on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*" },
	callback = function()
		vim.cmd([[:%s/\s\+$//e]])
	end,
})

-- stop eslint_d on exit
vim.api.nvim_create_autocmd("VimLeave", {
	pattern = { "*" },
	callback = function()
		if vim.fn.executable("eslint_d") == 1 then
			vim.cmd("!eslint_d stop &")
		end
	end,
})

-- statusline
vim.cmd([[set statusline=%<%f\ %h%m%r%{get(b:,'gitsigns_head','')}%=%-14.(%l,%c%V%)\ %P]])

-- plugin installation
require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use({
		"ellisonleao/gruvbox.nvim",
		config = function()
			vim.o.background = "dark"
			require("gruvbox").setup({ contrast = "hard" })
			vim.cmd("colorscheme gruvbox")
		end,
	})
	-- lsp
	use({
		"neovim/nvim-lspconfig",
		requires = {
			"hrsh7th/nvim-cmp",
			requires = {
				{ "hrsh7th/cmp-buffer" },
				{ "hrsh7th/cmp-cmdline" },
				{ "hrsh7th/cmp-nvim-lsp" },
				{ "hrsh7th/cmp-path" },
				{ "hrsh7th/cmp-vsnip" },
				{ "hrsh7th/vim-vsnip" },
				{ "johnpapa/vscode-angular-snippets" },
			},
			config = function()
				local cmp = require("cmp")
				local has_words_before = function()
					unpack = unpack or table.unpack
					local line, col = unpack(vim.api.nvim_win_get_cursor(0))
					return col ~= 0
						and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
				end
				local cmp_next = function(fallback)
					if vim.fn["vsnip#available"](1) == 1 then
						vim.call("vsnip#expand")
					elseif cmp.visible() then
						cmp.select_next_item()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end
				local cmp_prev = function(fallback)
					if vim.fn["vsnip#available"](-1) == 1 then
						vim.call("vsnip#expand")
					elseif cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end
				cmp.setup({
					snippet = {
						expand = function(args)
							vim.fn["vsnip#anonymous"](args.body)
						end,
					},
					mapping = cmp.mapping.preset.insert({
						["<C-Space>"] = cmp.mapping.complete(),
						["<C-b>"] = cmp.mapping.scroll_docs(-4),
						["<C-e>"] = cmp.mapping.abort(),
						["<C-f>"] = cmp.mapping.scroll_docs(4),
						["<C-n>"] = cmp.mapping(cmp_next, { "i", "s" }),
						["<C-p"] = cmp.mapping(cmp_prev, { "i", "s" }),
						["<CR>"] = cmp.mapping.confirm({ select = true }),
						["<Up>"] = cmp.mapping(cmp_prev, { "i", "s" }),
						["<Down>"] = cmp.mapping(cmp_next, { "i", "s" }),
						["<Tab>"] = cmp.mapping(cmp_next, { "i", "s", "c" }),
						["<S-Tab>"] = cmp.mapping(cmp_prev, { "i", "s", "c" }),
					}),
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "vsnip" },
					}, { { name = "buffer" } }),
				})
				cmp.setup.cmdline({ "/", "?" }, {
					mapping = cmp.mapping.preset.cmdline(),
					sources = { { name = "buffer" } },
				})
				cmp.setup.cmdline(":", {
					mapping = cmp.mapping.preset.cmdline(),
					sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
				})
			end,
		},
		config = function()
			vim.api.nvim_set_keymap("n", "<C-]>", "<CMD>lua vim.lsp.buf.definition()<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "<C-k>", "<CMD>lua vim.lsp.buf.signature_help()<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>ca", "<CMD>lua vim.lsp.buf.code_action()<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>dd", "<CMD>lua vim.diagnostic.open_float()<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>j", '<CMD>lua require("conform").format()<CR>', { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>rn", "<CMD>lua vim.lsp.buf.rename()<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "K", "<CMD>lua vim.lsp.buf.hover()<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "[d", "<CMD>lua vim.diagnostic.goto_prev()<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "]d", "<CMD>lua vim.diagnostic.goto_next()<CR>", { noremap = true })
			vim.diagnostic.config({ virtual_text = false })

			local lspconfig = require("lspconfig")
			lspconfig.tsserver.setup({
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
				on_attach = function(client)
					client.config.flags.allow_incremental_sync = true
					client.server_capabilities.semanticTokensProvider = nil
					client.server_capabilities.documentFormattingProvider = false
				end,
				init_options = { preferences = { importModuleSpecifierPreference = "relative" } },
			})
			lspconfig.angularls.setup({
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
				on_attach = function(client)
					client.config.flags.allow_incremental_sync = true
					client.server_capabilities.semanticTokensProvider = nil
					client.server_capabilities.documentFormattingProvider = false
				end,
			})
		end,
	})
	use({
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				typescript = { "eslint_d" },
				javascript = { "eslint_d" },
			}

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged", "TextChangedI" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	})
	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup()
		end,
	})
	-- project stuff
	use({
		"airblade/vim-rooter",
		config = function()
			vim.g.rooter_patterns = { ".git", "tsconfig.json", "angular.json", "project.json" }
		end,
	})
	-- formatters
	use({
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					typescript = { "eslint_d" },
					javascript = { "eslint_d" },
				},
			})
		end,
	})
	-- dirvish (file explorer)
	use({
		"justinmk/vim-dirvish",
		requires = { "roginfarrer/vim-dirvish-dovish" },
		config = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
			vim.g.dirvish_mode = [[:sort ,^\v(.*[\/])|\ze,]]
			vim.api.nvim_exec([[com! -nargs=? -complete=dir Explore Dirvish <args>]], false)
			vim.api.nvim_exec([[com! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>]], false)
			vim.api.nvim_exec([[com! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>]], false)
		end,
	})
	-- tree-sitter
	use({
		"dlvandenberg/nvim-treesitter",
		branch = "feature-angular",
		run = ":TSUpdate",
		requires = {
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				config = function()
					vim.g.skip_ts_context_commentstring_module = true
				end,
			},
			"nvim-treesitter/playground",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"css",
					"go",
					"html",
					"javascript",
					"json",
					"lua",
					"make",
					"markdown",
					"python",
					"query",
					"ruby",
					"rust",
					"scss",
					"typescript",
					"yaml",
				},
				highlight = { enable = true },
				context_commentstring = { enable = true },
				query_linter = {
					enable = true,
					use_virtual_text = true,
					lint_events = { "BufWrite", "CursorHold" },
				},
			})
		end,
	})
	-- git
	use({
		"lewis6991/gitsigns.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })
					map("n", "<leader>gr", gs.reset_hunk)
					map("v", "<leader>gr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("n", "<leader>gp", gs.preview_hunk)
				end,
			})
		end,
	})
	use({
		"tpope/vim-fugitive",
		config = function()
			vim.api.nvim_set_keymap("n", "<leader>gs", "<CMD>Git<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>gb", "<CMD>Git blame<CR>", { noremap = true })
		end,
	})
	-- tpope
	use("tpope/vim-commentary")
	use("tpope/vim-repeat")
	use("tpope/vim-sleuth")
	use("tpope/vim-surround")
	-- telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({ extensions = { ["ui-select"] = require("telescope.themes").get_cursor() } })
			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")
			vim.api.nvim_set_keymap(
				"n",
				"<leader>fb",
				[[<CMD>lua require('telescope.builtin').buffers(require('telescope.themes').get_ivy())<CR>]],
				{ noremap = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>fc",
				[[<CMD>lua require('telescope.builtin').command_history()<CR>]],
				{ noremap = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>fd",
				[[<CMD>lua require('telescope.builtin').diagnostics(require('telescope.themes').get_ivy())<CR>]],
				{ noremap = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>ff",
				[[<CMD>lua require('telescope.builtin').live_grep(require('telescope.themes').get_ivy())<CR>]],
				{ noremap = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>fh",
				[[<CMD>lua require('telescope.builtin').oldfiles(require('telescope.themes').get_ivy())<CR>]],
				{ noremap = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>fp",
				[[<CMD>lua require('telescope.builtin').find_files(require('telescope.themes').get_ivy())<CR>]],
				{ noremap = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>rr",
				[[<CMD>lua require('telescope.builtin').registers(require('telescope.themes').get_ivy())<CR>]],
				{ noremap = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>fr",
				[[<CMD>lua require('telescope.builtin').lsp_references(require('telescope.themes').get_ivy())<CR>]],
				{ noremap = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>fs",
				[[<CMD>lua require('telescope.builtin').lsp_document_symbols(require('telescope.themes').get_ivy())<CR>]],
				{ noremap = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>ft",
				[[<CMD>lua require('telescope.builtin').colorscheme()<CR>]],
				{ noremap = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>fw",
				[[<CMD>lua require('telescope.builtin').grep_string(require('telescope.themes').get_ivy({default_text = vim.fn.expand('<cword>')}))<CR>]],
				{ noremap = true }
			)
		end,
	})
	-- buffers
	use({
		"moll/vim-bbye",
		config = function()
			vim.api.nvim_set_keymap(
				"n",
				"<leader>bo",
				[[<CMD>lua for _, number in ipairs(vim.api.nvim_list_bufs()) do if number ~= vim.api.nvim_get_current_buf() then vim.cmd('Bdelete ' .. number) end end<CR>]],
				{ noremap = true }
			)
			vim.api.nvim_set_keymap("n", "<leader>bd", "<CMD>Bdelete<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "[b", "<CMD>bp<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "]b", "<CMD>bn<CR>", { noremap = true })
		end,
	})
end)
