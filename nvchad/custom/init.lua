local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

-- Highlight yanks
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

-- Cursorline hack because NVChad
autocmd("VimEnter", { pattern = { "*" }, command = "highlight link Cursorline CursorColumn" })
