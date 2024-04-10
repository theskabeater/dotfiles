-- global settings
vim.g.mapleader = " "
vim.o.background = "dark"
vim.o.backup = false
vim.o.clipboard = "unnamedplus"
vim.o.diffopt = "vertical"
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.inccommand = "nosplit"
vim.o.incsearch = true
vim.o.iskeyword = vim.o.iskeyword .. ",@-@,$"
vim.o.mouse = "a"
vim.o.shiftwidth = 2
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.showmode = false
vim.o.smartcase = true
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.updatetime = 100
vim.o.writebackup = false
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"

-- misc autocmds
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.component.html" },
	callback = function()
		vim.bo.filetype = "angular"
	end,
})

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

-- non-plugin keymaps
local close_on_esc = function()
	for _, ft in ipairs({ "fugitive" }) do
		if vim.bo.ft == ft then
			return vim.cmd.normal("gq")
		end
	end
	for _, ft in ipairs({ "lazy" }) do
		if vim.bo.ft == ft then
			return vim.cmd.normal("q")
		end
	end
end
vim.keymap.set("n", "<Esc>", close_on_esc)

local close_other_buffers = function()
	local cur_bufnr = vim.api.nvim_get_current_buf()
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) and bufnr ~= cur_bufnr then
			vim.api.nvim_buf_delete(bufnr, {})
		end
	end
end

vim.keymap.set("n", "]b", "<CMD>bn<CR>")
vim.keymap.set("n", "[b", "<CMD>bp<CR>")
vim.keymap.set("n", "<leader>bo", close_other_buffers)

-- plugin stuff below, bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- add rounded border with highlight group
local border = function(hl)
	return {
		{ "╭", hl },
		{ "─", hl },
		{ "╮", hl },
		{ "│", hl },
		{ "╯", hl },
		{ "─", hl },
		{ "╰", hl },
		{ "│", hl },
	}
end

-- shared between lazy and mason
local ui = { border = "rounded", size = { width = 0.8, height = 0.8 } }

-- shared lsp stuff
local lsp_on_init = function(client, _)
	if client.supports_method("textDocument/semanticTokens") then
		client.server_capabilities.semanticTokensProvider = nil
	end
end

local lsp_handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border("FloatBorder") }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border("FloatBorder") }),
}

local lsp_capabilities = function()
	-- don't call this unless until cmp is loaded
	require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
end

local plugins = {
	"nvim-lua/plenary.nvim",

	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		config = function()
			local gruvbox = require("gruvbox")

			gruvbox.setup({
				contrast = "hard",
				overrides = {
					-- recolor signcolumn so it matches gitsigns
					SignColumn = { link = "LineNr" },
					-- recolor signcolumn diagnostics
					DiagnosticSignError = { link = "GruvboxRedBold" },
					DiagnosticSignOk = { link = "GruvboxGreenBold" },
					DiagnosticSignHint = { link = "GruvboxPurpleBold" },
					DiagnosticSignInfo = { link = "GruvboxBoldBold" },
					DiagnosticSignWarn = { link = "GruvboxYellowBold" },
					-- recolor cursorline
					CursorLine = { bg = gruvbox.palette.dark0 },
					-- recolor linenumber on cursorline
					CursorLineNr = {
						fg = gruvbox.palette.bright_yellow,
						bg = gruvbox.palette.dark0,
						bold = true,
					},
					-- recolor float windows
					NormalFloat = { bg = gruvbox.palette.dark0_hard },
					FloatBorder = { fg = gruvbox.palette.bright_blue },
					LspInfoBorder = { link = "FloatBorder" },
				},
			})

			vim.cmd("colorscheme gruvbox")
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
		"theskabeater/vim-kitty-navigator",
		enabled = true,
		build = "cp *.py $HOME/.config/kitty/",
		init = function()
			vim.g.kitty_navigator_no_mappings = 1
			vim.keymap.set("n", "<C-w>h", "<CMD>KittyNavigateLeft<CR>")
			vim.keymap.set("n", "<C-w><C-h>", "<cmd>KittyNavigateLeft<CR>")
			vim.keymap.set("n", "<C-w>j", "<CMD>KittyNavigateDown<CR>")
			vim.keymap.set("n", "<C-w><C-j>", "<cmd>KittyNavigateDown<CR>")
			vim.keymap.set("n", "<C-w>k", "<CMD>KittyNavigateUp<CR>")
			vim.keymap.set("n", "<C-w><C-k>", "<cmd>KittyNavigateUp<CR>")
			vim.keymap.set("n", "<C-w>l", "<CMD>KittyNavigateRight<CR>")
			vim.keymap.set("n", "<C-w><C-l>", "<cmd>KittyNavigateRight<CR>")
			vim.keymap.set("n", "<C-w>w", "<CMD>KittyNavigateNext<CR>")
			vim.keymap.set("n", "<C-w><C-w>", "<cmd>KittyNavigateNext<CR>")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufNewFile", "BufReadPre" },
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"angular",
					"bash",
					"css",
					"go",
					"graphql",
					"html",
					"java",
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
					"vimdoc",
					"yaml",
				},
				auto_install = true,
				highlight = { enable = true },
			})
		end,
	},

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		ft = { "typescript" },
		dependencies = { { "nvim-treesitter/nvim-treesitter" } },
		config = function()
			require("ts_context_commentstring").setup({
				languages = { angular = "<!-- %s -->" },
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		ft = { "angular", "lua", "javascript", "typescript" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall" },
		dependencies = {
			{ "hrsh7th/nvim-cmp" },
			{
				"williamboman/mason.nvim",
				dependencies = { "williamboman/mason-lspconfig.nvim" },
				cmd = "Mason",
				config = function()
					require("mason").setup({ ui = ui })
					require("mason-lspconfig").setup({
						automatic_installation = true,
						ensure_installed = { "angularls", "lua_ls", "tsserver" },
					})
				end,
			},
		},
		config = function()
			local lspconfig = require("lspconfig")

			require("lspconfig.ui.windows").default_options.border = "rounded"
			vim.diagnostic.config({ virtual_text = false })

			local angular_project_roots = { "nx.json" }
			local angular_project_root = vim.fs.dirname(vim.fs.find(angular_project_roots, { upward = true })[1])
			if angular_project_root then
				local angularls_cmd = {
					"ngserver",
					"--stdio",
					"--tsProbeLocations",
					vim.fn.stdpath("data") .. "/mason/packages/typescript-language-server/node_modules",
					"--ngProbeLocations",
					angular_project_root,
				}
				lspconfig.angularls.setup({
					on_init = lsp_on_init,
					handlers = lsp_handlers,
					capabilities = lsp_capabilities(),
					cmd = angularls_cmd,
					root_dir = lspconfig.util.root_pattern(angular_project_roots),
					filetypes = { "angular", "typescript" },
					on_new_config = function(new_config, _)
						new_config.cmd = angularls_cmd
					end,
				})
			end

			lspconfig.lua_ls.setup({
				on_init = lsp_on_init,
				handlers = lsp_handlers,
				capabilities = lsp_capabilities(),
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
								[vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
							},
							maxPreload = 100000,
							preloadFileSize = 10000,
						},
					},
				},
			})

			vim.keymap.set("n", "<C-]>", "<CMD>lua vim.lsp.buf.definition()<CR>")
			vim.keymap.set("n", "<C-k>", "<CMD>lua vim.lsp.buf.signature_help()<CR>")
			vim.keymap.set("n", "<leader>ca", "<CMD>lua vim.lsp.buf.code_action()<CR>")
			vim.keymap.set("n", "<leader>dd", "<CMD>lua vim.diagnostic.open_float()<CR>")
			vim.keymap.set("n", "<leader>rn", "<CMD>lua vim.lsp.buf.rename()<CR>")
			vim.keymap.set("n", "K", "<CMD>lua vim.lsp.buf.hover()<CR>")
			vim.keymap.set("n", "[d", "<CMD>lua vim.diagnostic.goto_prev()<CR>")
			vim.keymap.set("n", "]d", "<CMD>lua vim.diagnostic.goto_next()<CR>")
		end,
	},

	{
		"pmizio/typescript-tools.nvim",
		dependencies = { { "neovim/nvim-lspconfig" } },
		filetypes = { "angular", "typescript" },
		config = function()
			require("typescript-tools").setup({
				on_init = lsp_on_init,
				handlers = lsp_handlers,
				capabilities = lsp_capabilities(),
			})
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter" },
		dependencies = {
			{
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-nvim-lsp-signature-help",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
			},
			{
				"L3MON4D3/LuaSnip",
				dependencies = { "rafamadriz/friendly-snippets", "johnpapa/vscode-angular-snippets" },
				config = function()
					require("luasnip").config.set_config({
						{ history = true, updateevents = "TextChanged,TextChangedI" },
					})

					-- vscode format
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.g.vscode_snippets_path or "" })

					-- snipmate format
					require("luasnip.loaders.from_snipmate").load()
					require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.g.snipmate_snippets_path or "" })

					-- lua format
					require("luasnip.loaders.from_lua").load()
					require("luasnip.loaders.from_lua").lazy_load({ paths = vim.g.lua_snippets_path or "" })

					vim.api.nvim_create_autocmd("InsertLeave", {
						callback = function()
							if
								require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
								and not require("luasnip").session.jump_active
							then
								require("luasnip").unlink_current()
							end
						end,
					})
				end,
			},
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				preselect = cmp.PreselectMode.None,
				completion = {
					completeopt = "menu,menuone,noselect",
					autocomplete = false,
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
						border = border("FloatBorder"),
						scrollbar = false,
					},
					documentation = {
						winhighlight = "Normal:CmpDoc",
						border = border("FloatBorder"),
						scrollbar = false,
					},
				},
				mapping = {
					["<C-p>"] = function()
						if cmp.visible() then
							cmp.select_prev_item()
						else
							cmp.complete()
						end
					end,
					["<C-n>"] = function()
						if cmp.visible() then
							cmp.select_next_item()
						else
							cmp.complete()
						end
					end,
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif require("luasnip").expand_or_jumpable() then
							vim.fn.feedkeys(
								vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
								""
							)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif require("luasnip").jumpable(-1) then
							vim.fn.feedkeys(
								vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true),
								""
							)
						else
							fallback()
						end
					end, { "i", "s" }),
				},
				sources = {
					{ name = "nvim_lsp_signature_help" },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "nvim_lua" },
					{ name = "path" },
				},
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

	{
		"mfussenegger/nvim-lint",
		ft = { "javascript", "typescript" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
			}

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged", "TextChangedI" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},

	{
		"stevearc/conform.nvim",
		keys = {
			{ "<leader>j", '<CMD>lua require("conform").format({ async = true, lsp_fallback = true})<CR>' },
		},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					angular = { "prettierd" },
					html = { "prettierd" },
					javascript = { "prettierd" },
					json = { "prettierd" },
					lua = { "stylua" },
					scss = { "prettierd" },
					typescript = { "prettierd", "eslint_d" },
				},
			})
		end,
	},

	{
		"joeveiga/ng.nvim",
		keys = {
			{ "<leader>ac", "<CMD>lua require('ng').goto_component_with_template_file()<CR>" },
			{ "<leader>at", "<CMD>lua require('ng').goto_template_for_component()<CR>" },
			{ "<leader>aT", "<CMD>lua require('ng').get_template_tcb()<CR>" },
		},
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
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
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					path_display = { "truncate" },
				},
				pickers = {
					current_buffer_fuzzy_find = { theme = "ivy", previewer = false },
					buffers = { theme = "ivy" },
					diagnostics = { theme = "ivy" },
					find_files = { theme = "ivy" },
					grep_string = { theme = "ivy" },
					help_tags = { theme = "ivy" },
					live_grep = { theme = "ivy" },
					lsp_references = { theme = "ivy" },
					lsp_symboles = { theme = "ivy" },
					oldfiles = { theme = "ivy" },
					registers = { theme = "ivy", previewer = false },
				},
			})

			telescope.load_extension("fzf")
		end,
	},

	{
		"stevearc/oil.nvim",
		keys = { { "-", "<CMD>Oil<CR>" } },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				view_options = { show_hidden = true },
				keymaps = {
					["g?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<C-s>"] = "actions.select_vsplit",
					["<C-h>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					["<C-p>"] = "actions.preview",
					["<C-c>"] = "actions.close",
					["<Esc>"] = "actions.close",
					["<C-l>"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = "actions.tcd",
					["gs"] = "actions.change_sort",
					["gx"] = "actions.open_external",
					["g\\"] = "actions.toggle_trash",
				},
			})
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
		event = { "BufNewFile", "BufReadPre" },
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
	},

	{
		"moll/vim-bbye",
		keys = { { "<leader>bd", "<CMD>Bdelete<CR>", "n" } },
	},
}
require("lazy").setup(plugins, {
	ui = ui,
	performance = {
		rtp = {
			disabled_plugins = {
				"2html_plugin",
				"tohtml",
				"getscript",
				"getscriptPlugin",
				"gzip",
				"logipat",
				"netrw",
				"netrwPlugin",
				"netrwSettings",
				"netrwFileHandlers",
				"matchit",
				"tar",
				"tarPlugin",
				"rrhelper",
				"spellfile_plugin",
				"vimball",
				"vimballPlugin",
				"zip",
				"zipPlugin",
				"tutor",
				"rplugin",
				"syntax",
				"synmenu",
				"optwin",
				"compiler",
				"bugreport",
			},
		},
	},
})
