local M = {}

-- create rounded border with hl group
M.border = function(hl)
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

--  ui settings for lazy and mason
M.ui = {
	border = "rounded",
	size = {
		width = 0.8,
		height = 0.8,
	},
}

-- lsp settings
M.on_init = function(client, _)
	if client.supports_method("textDocument/semanticTokens") then
		client.server_capabilities.semanticTokensProvider = nil
	end
end

M.handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = M.border("FloatBorder") }),
	["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{ border = M.border("FloatBorder") }
	),
}

M.capabilities = function() require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()) end

return M
