local packer = require('packer')
local use = packer.use

return packer.startup(function()
    -- General
    use 'airblade/vim-rooter'
    use 'norcalli/nvim_utils'
    use 'tpope/vim-commentary'
    use 'tpope/vim-sleuth'
    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'
    use 'unblevable/quick-scope'
    use 'wbthomason/packer.nvim'

    -- Color scheme
    use 'chriskempson/base16-vim'

    -- LSP
    use 'glepnir/lspsaga.nvim'
    use 'hrsh7th/nvim-compe'
    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/lsp-status.nvim'

    -- Fuzzy finder
    use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}}
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}

    -- Search and replace
    use {'windwp/nvim-spectre', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}}

    -- File explorer
    use 'justinmk/vim-dirvish'
    use 'roginfarrer/vim-dirvish-dovish'

    -- Git
    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
    use 'tpope/vim-fugitive'

    -- Treesitter
    use 'JoosepAlviste/nvim-ts-context-commentstring'
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/nvim-treesitter-angular'

    -- Status line
    use 'romgrk/barbar.nvim'
    use 'hoob3rt/lualine.nvim'
end)
