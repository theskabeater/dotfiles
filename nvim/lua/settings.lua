-- Globals
vim.g.mapleader = ' '

-- Global options
vim.o.backup = false
vim.o.clipboard = 'unnamedplus'
vim.o.completeopt= 'menuone,noselect'
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

-- Buffer options
vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.smartindent = true
vim.bo.autoindent = true

-- Window options
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes'

-- Cmds
vim.cmd('set nohls')
vim.cmd('set noswapfile')
