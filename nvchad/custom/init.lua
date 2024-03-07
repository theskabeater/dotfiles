local autocmd = vim.api.nvim_create_autocmd

--- Highlight yanks
autocmd("TextYankPost", {
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
	end,
})

-- Trim trailing space on save
autocmd("BufWritePre", {
	pattern = { "*" },
	callback = function()
		vim.cmd([[:%s/\s\+$//e]])
	end,
})

-- Stop eslint_d on exit
vim.api.nvim_create_autocmd("VimLeave", {
	pattern = { "*" },
	callback = function()
		if vim.fn.executable("eslint_d") == 1 then
			vim.cmd("!eslint_d stop &")
		end
	end,
})

-- Set angular filetype
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.component.html" },
	callback = function()
		vim.bo.filetype = "angular"
	end,
})

for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
	vim.api.nvim_set_hl(0, group, {})
end

-- Vim global settings
vim.opt.relativenumber = true
