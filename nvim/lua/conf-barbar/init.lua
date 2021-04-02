-- Options
local bufferline = vim.g.bufferline or {}
bufferline.icons = false
bufferline.animation = false
bufferline.icon_separator_active = '│'
bufferline.icon_separator_inactive = '│'
vim.g.bufferline = bufferline


-- Keybinds
vim.api.nvim_set_keymap('n', '[b', ':BufferPrevious<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', ']b', ':BufferNext<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>bd', ':BufferClose<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>bo', ':BufferCloseAllButCurrent<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>bp', ':BufferPick<CR>', {silent = true, noremap = true})
