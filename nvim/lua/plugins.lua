local packer = require('packer')

return packer.startup(function()
	-- General
	use 'airblade/vim-rooter'
	use 'norcalli/nvim_utils'
	use 'nvim-lua/plenary.nvim'
	use 'tpope/vim-commentary'
	use 'tpope/vim-sleuth'
	use 'tpope/vim-repeat'
	use 'tpope/vim-surround'
	use 'unblevable/quick-scope'
	use 'wbthomason/packer.nvim'

	-- Snippets
	use 'capaj/vscode-standardjs-snippets'
	use 'hrsh7th/vim-vsnip'
	use 'hrsh7th/vim-vsnip-integ'
	use 'johnpapa/vscode-angular-snippets'

	-- Color scheme
	use 'chriskempson/base16-vim'

	-- LSP
	use 'glepnir/lspsaga.nvim'
	use 'hrsh7th/nvim-compe'
	use 'neovim/nvim-lspconfig'

	-- Fuzzy finder
	use {'junegunn/fzf', run = ':call fzf#install()'}
	use 'junegunn/fzf.vim'
	use 'ojroques/nvim-lspfuzzy'

	-- File explorer
	use 'justinmk/vim-dirvish'
	use 'roginfarrer/vim-dirvish-dovish'

	-- Git
	use 'lewis6991/gitsigns.nvim'
	use 'tpope/vim-fugitive'

	-- Treesitter
	use 'nvim-treesitter/nvim-treesitter'
	use 'nvim-treesitter/nvim-treesitter-angular'

	-- Status line
	use 'romgrk/barbar.nvim'
end)
