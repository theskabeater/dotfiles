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
vim.wo.signcolumn = 'yes'

-- Cmds
vim.cmd('set nohls')
vim.cmd('set noswapfile')
