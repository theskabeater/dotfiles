require 'nvim_utils'

-- Keybindings
vim.api.nvim_set_keymap('n', '<leader>gs', ':Git<CR>', {silent = true, noremap = true})
_G.ska.set_vim_fugitive_keybinds = function()
    vim.api.nvim_buf_set_keymap(0, '', '<Esc>', ':normal gq<CR>', {silent = true, noremap = true})
    vim.api.nvim_buf_set_keymap(0, '', '<C-c>', ':normal gq<CR>', {silent = true, noremap = true})
    vim.api.nvim_buf_set_keymap(0, '', '<C-[>', ':normal gq<CR>', {silent = true, noremap = true})
end

nvim_create_augroups({vim_fugitive_keybinds = {{'FileType', 'fugitive', 'silent! lua _G.ska.set_vim_fugitive_keybinds()'}}})
