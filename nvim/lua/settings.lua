-- Globals
vim.g.mapleader = ' '

-- Global options
vim.o.backup = false
vim.o.clipboard = 'unnamedplus'
vim.o.diffopt = 'vertical'
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.inccommand = 'nosplit'
vim.o.incsearch = true
vim.o.iskeyword = vim.o.iskeyword .. ',@-@,$'
vim.o.mouse = 'a'
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.showmode = false
vim.o.smartcase = true
vim.o.updatetime = 100
vim.o.writebackup = false

-- Window options
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes'

-- Cmds
vim.cmd('set nohls')
vim.cmd('set noswapfile')

-- Dev stuff
_G.ska.dev = function()

    os.execute(': > ' .. os.getenv('HOME') .. '/log')
    local clients = vim.lsp.get_active_clients()
    vim.lsp.stop_client(clients)
    vim.cmd('edit')
end
vim.api.nvim_set_keymap('n', '<leader>ww', [[<Cmd> lua _G.ska.dev()<CR>]], {silent = true, noremap = true})
