local M = {}

M.treesitter = {
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
	indent = {
		enable = true,
		-- disable = {
		--   "python"
		-- },
	},
}

M.mason = {
	ensure_installed = {
		-- lua stuff
		"lua-language-server",
		"stylua",

		-- web dev stuff
		"typescript-language-server",
		"angular-language-server@16.1.4",
	},
}

-- git support in nvimtree
M.nvimtree = {
	git = {
		enable = true,
	},

	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
			},
		},
	},
}

M.telescope = {
	pickers = {
		buffers = {
			theme = "ivy",
		},
		command_history = {
			theme = "ivy",
		},
		diagnostics = {
			theme = "ivy",
		},
		live_grep = {
			theme = "ivy",
		},
		oldfiles = {
			theme = "ivy",
		},
		find_files = {
			theme = "ivy",
		},
		lsp_references = {
			theme = "ivy",
		},
		lsp_document_symbols = {
			theme = "ivy",
		},
		current_buffer_fuzzy_find = {
			previewer = false,
			theme = "ivy",
		},
		registers = {
			theme = "ivy",
		},
		help_tags = {
			previewer = false,
			theme = "ivy",
		},
	},
}

return M
