-- settings

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

-- autocmds

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

-- keymaps

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
vim.keymap.set("n", "<leader>bd", "<CMD>bd<CR>")
vim.keymap.set("n", "<leader>bo", close_other_buffers)
