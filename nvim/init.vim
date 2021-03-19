call plug#begin('~/.config/nvim/plugged')

Plug 'airblade/vim-rooter'
Plug 'capaj/vscode-standardjs-snippets'
Plug 'chriskempson/base16-vim'
Plug 'glepnir/lspsaga.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'johnpapa/vscode-angular-snippets'
Plug 'justinmk/vim-dirvish'
Plug 'lewis6991/gitsigns.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-angular'
Plug 'roginfarrer/vim-dirvish-dovish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'unblevable/quick-scope'

call plug#end()

source $HOME/.config/nvim/vim/config/general.vim
source $HOME/.config/nvim/vim/config/colorscheme.vim
source $HOME/.config/nvim/vim/config/dirvish.vim
source $HOME/.config/nvim/vim/config/rooter.vim
source $HOME/.config/nvim/vim/config/lsp.vim
source $HOME/.config/nvim/vim/config/lspsaga.vim
source $HOME/.config/nvim/vim/config/compe.vim
source $HOME/.config/nvim/vim/config/git.vim
source $HOME/.config/nvim/vim/config/quick-scope.vim
source $HOME/.config/nvim/vim/config/telescope.vim

lua require('config/treesitter')
lua require('config/lsp')
lua require('config/lspsaga')
lua require('config/compe')
lua require('config/gitsigns')
lua require('config/telescope')
