-- Options
local bufferline = vim.g.bufferline or {}
bufferline.icons = false
bufferline.animation = false
vim.g.bufferline = bufferline

-- Keybinds
vim.api.nvim_set_keymap('n', '[b', ':BufferPrevious<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', ']b', ':BufferNext<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', 'bd', ':BufferClose<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', 'bo', ':BufferCloseAllButCurrent<CR>', {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', 'bp', ':BufferPick<CR>', {silent = true, noremap = true})
