local gruvbox = require("gruvbox")

gruvbox.setup({
	contrast = "hard",
	overrides = {
		SignColumn = { link = "LineNr" },
		DiagnosticSignError = { link = "GruvboxRedBold" },
		DiagnosticSignOk = { link = "GruvboxGreenBold" },
		DiagnosticSignHint = { link = "GruvboxPurpleBold" },
		DiagnosticSignInfo = { link = "GruvboxBoldBold" },
		DiagnosticSignWarn = { link = "GruvboxYellowBold" },
		CursorLine = { bg = gruvbox.palette.dark0 },
		CursorLineNr = {
			fg = gruvbox.palette.bright_yellow,
			bg = gruvbox.palette.dark0,
			bold = true,
		},
		PmenuThumb = { bg = gruvbox.palette.dark1 },
	},
})

vim.cmd("colorscheme gruvbox")
