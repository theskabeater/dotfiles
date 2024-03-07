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
}

M.mason = {
	ensure_installed = {
		"lua-language-server",
		"stylua",
		"angular-language-server@16.1.4",
	},
}

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
	defaults = {
		path_display = { "smart" },
	},
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
		grep_string = {
			theme = "ivy",
		},
		help_tags = {
			previewer = false,
			theme = "ivy",
		},
	},
}

M.nvterm = {
	terminals = {
		type_opts = {
			float = {
        row = 0.1,
        col = 0.1,
				width = 0.8,
				height = 0.6,
			},
		},
	},
}

return M
