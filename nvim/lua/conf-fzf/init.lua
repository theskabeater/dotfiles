-- Environment
vim.env.FZF_DEFAULT_COMMAND = [[ag -g '']]
vim.env.FZF_DEFAULT_OPTS = [[--preview 'bat --theme=base16' --bind ctrl-d:preview-down --bind ctrl-u:preview-up]]

-- Options
vim.g.fzf_layout = {
    window = {
	width = 1.0,
	height = 0.4,
	yoffset = 1.0,
	border = 'horizontal',
    },
}

vim.g.fzf_colors = {
    bg = {'bg', 'Normal'},
    ['bg+'] = {'bg', 'CursorLine', 'CursorColumn'},
    border = {'fg', 'Ignore'},
    fg = {"fg", 'Normal'};
    ['fg+'] = {'fg', 'CursorLine', 'CursorColumn', 'Normal'},
    hl = {'fg', 'Comment'},
    header = {'fg', 'Comment'},
    ['hl+'] = {'fg', 'Statement'},
    info = {'fg', 'PreProc'},
    marker = {'fg', 'Keyword'},
    pointer = {'fg', 'Exception'},
    prompt = {'fg', 'Conditional'},
    spinner = {'fg', 'Label'},
}

-- Custom commands
vim.api.nvim_exec(
[[
" Ag command
com! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

" Buffers command
com! -bang -nargs=? -complete=dir Buffers call fzf#vim#buffers(<q-args>, fzf#vim#with_preview(), <bang>0)

" Hist command
com! -bang -nargs=* Hist call fzf#vim#history(fzf#vim#with_preview())

" Line command
com! -bang -nargs=* Line call fzf#vim#lines({'options': '--no-preview'})

" BLine command
com! -bang -nargs=* BLines call fzf#vim#lines({'options': '--no-preview'})

" Color command
com! -bang -nargs=* Color call fzf#vim#colors({'options': '--no-preview'})

fun! SearchWordWithAg()
    execute 'Ag' expand('<cword>')
endfun

fun! SearchVisualSelectionWithAg() range
    let old_reg = getreg('"')
    let old_regtype = getregtype('"')
    let old_clipboard = &clipboard
    set clipboard&
    normal! ""gvy
    let selection = getreg('"')
    call setreg('"', old_reg, old_regtype)
    let &clipboard = old_clipboard
    execute 'Ag' selection
endfun
]], false)

-- Keybinds
vim.api.nvim_set_keymap('n', '<leader>ff', ':Ag<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fo', ':BLine<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fb', ':Buffers<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ft', ':Color<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fc', ':Commands<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fp', ':Files<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fh', ':Hist<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fl', ':Line<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fm', ':Marks<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fw', ':call SearchWordWithAg()<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('v', '<leader>fw', ':call SearchVisualSelectionWithAg()<CR>', {silent = true, noremap = true})
