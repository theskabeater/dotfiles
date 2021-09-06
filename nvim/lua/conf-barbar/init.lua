-- Options
local bufferline = vim.g.bufferline or {}
bufferline.icons = false
bufferline.animation = false
bufferline.maximum_padding = 2
bufferline.add_in_buffer_number_order = true
bufferline.maximum_length = 50
vim.g.bufferline = bufferline

-- Keybinds
vim.api.nvim_set_keymap('n', '[b', ':BufferPrevious<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', ']b', ':BufferNext<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>bd', ':BufferClose<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>bo', ':BufferCloseAllButCurrent<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>bp', ':BufferPick<CR>', {silent = true, noremap = true})
