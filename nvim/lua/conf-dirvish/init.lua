require 'nvim_utils'

vim.g.dirvish_mode = [[:sort ,^\v(.*[\/])|\ze,]]
vim.g.loaded_netrwPlugin=1

vim.api.nvim_exec(
[[
com! -nargs=? -complete=dir Explore Dirvish <args>
com! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
com! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
]], false)

-- Keybindings
_G.ska.set_dirvish_settings = function()
	vim.cmd('setlocal bufhidden=wipe')
	vim.api.nvim_buf_del_keymap(0, '', 'p')
	vim.api.nvim_buf_set_keymap(0, '', 'p', '<Plug>(dovish_copy)', {silent = true, noremap = true})
	vim.api.nvim_buf_set_keymap(0, '', 'P', '<Plug>(dovish_move)', {silent = true, noremap = true})
	vim.api.nvim_buf_set_keymap(0, '', '<Esc>', ':normal gq<CR>', {silent = true, noremap = true})
	vim.api.nvim_buf_set_keymap(0, '', '<C-c>', ':normal gq<CR>', {silent = true, noremap = true})
	vim.api.nvim_buf_set_keymap(0, '', '<C-[>', ':normal gq<CR>', {silent = true, noremap = true})
end

nvim_create_augroups({
	set_dirvish_settings = {
		{'FileType', 'dirvish', 'silent! lua _G.ska.set_dirvish_settings()'},
	},
})
