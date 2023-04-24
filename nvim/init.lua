vim.g.mapleader = ' '
vim.o.backup = false
vim.o.clipboard = 'unnamedplus'
vim.o.expandtab = true;
vim.o.diffopt = 'vertical'
vim.o.ignorecase = true
vim.o.inccommand = 'nosplit'
vim.o.incsearch = true
vim.o.iskeyword = vim.o.iskeyword .. ',@-@,$'
vim.o.mouse = 'a'
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.showmode = false
vim.o.shiftwidth = 2;
vim.o.smartcase = true
vim.o.softtabstop = 2;
vim.o.tabstop = 2;
vim.o.updatetime = 100
vim.o.writebackup = false
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.termguicolors = true
vim.o.background = 'dark'
vim.wo.signcolumn = 'yes'

vim.api.nvim_set_keymap('n', '<C-l>', [[<CMD>noh<CR>]], { noremap = true })
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = "*",
  callback = function()
    vim.cmd('setlocal formatoptions-=c formatoptions-=r formatoptions-=o')
  end
})
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = "*",
  callback = function()
    vim.cmd('!pkill eslint_d')
  end,
})
vim.api.nvim_create_autocmd('VimLeave', {
  pattern = "*",
  callback = function()
    vim.cmd([[:%s/\s\+$//e]])
  end,
})
vim.cmd([[set statusline=%<%f\ %h%m%r%{get(b:,'gitsigns_head','')}%=%-14.(%l,%c%V%)\ %P]])

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd('packadd packer.nvim')
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use {
    'airblade/vim-rooter',
    config = function()
      vim.g.rooter_patterns = { '.git', 'package.json' }
    end,
  }
  use { 'JoosepAlviste/nvim-ts-context-commentstring' }
  use { 'elgiano/nvim-treesitter-angular', branch = 'topic/jsx-fix' }
  use {
    'ellisonleao/gruvbox.nvim',
    config = function()
      require('gruvbox').setup({ contrast = 'hard' })
      vim.cmd('colorscheme gruvbox')
    end,
  }
  use { 'j-hui/fidget.nvim', config = function() require 'fidget'.setup {} end }
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.formatting.eslint_d,
        },
      })
    end
  }
  use {
    'junegunn/goyo.vim',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>gg', '<CMD>Goyo<CR>', {noremap = true})
    end,
  }
  use {
    'justinmk/vim-dirvish',
    requires = { { 'roginfarrer/vim-dirvish-dovish' } },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.g.dirvish_mode = [[:sort ,^\v(.*[\/])|\ze,]]
      vim.api.nvim_exec([[com! -nargs=? -complete=dir Explore Dirvish <args>]], false)
      vim.api.nvim_exec([[com! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>]], false)
      vim.api.nvim_exec([[com! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>]], false)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'dirvish',
        callback = function()
          vim.cmd([[silent! lua vim.api.nvim_set_keymap('', 'p')]])
          vim.cmd([[silent! lua vim.api.nvim_set_keymap('', '<Esc>', ':normal gq<CR>', {noremap = true})]])
          vim.cmd([[silent! lua vim.api.nvim_set_keymap('', '<C-c>', ':normal gq<CR>', {noremap = true})]])
          vim.cmd([[silent! lua vim.api.nvim_set_keymap('', '<C-[>', ':normal gq<CR>', {noremap = true})]])
        end,
      })
    end,
  }
  use {
    'lewis6991/gitsigns.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = function()
      require('gitsigns').setup({
        keymaps = {
          noremap = true,
          ['n ]c'] = { expr = true, '&diff ? \']c\' : \'<CMD>lua require"gitsigns.actions".next_hunk()<CR>\'' },
          ['n [c'] = { expr = true, '&diff ? \'[c\' : \'<CMD>lua require"gitsigns.actions".prev_hunk()<CR>\'' },
          ['n <leader>gr'] = '<CMD>lua require"gitsigns".reset_hunk()<CR>',
          ['v <leader>gr'] = '<CMD>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
          ['n <leader>gp'] = '<CMD>lua require"gitsigns".preview_hunk()<CR>',
          ['n <leader>gb'] = '<CMD>Git blame<CR>',
        }
      })
    end,
  }
  use {
    'moll/vim-bbye',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>bo',
        [[<CMD>lua for _, number in ipairs(nvim.list_bufs()) do if number ~= nvim.get_current_buf() then vim.cmd('Bdelete ' .. number) end end<CR>]],
        { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>bd', '<CMD>Bdelete<CR>', { noremap = true })
      vim.api.nvim_set_keymap('n', '[b', '<CMD>bp<CR>', { noremap = true })
      vim.api.nvim_set_keymap('n', ']b', '<CMD>bn<CR>', { noremap = true })
    end,
  }
  use {
    'ms-jpq/coq_nvim',
    requires = { { 'ms-jpq/coq.artifacts' }, { 'ms-jpq/coq.thirdparty' } },
    run = 'python3 -m coq deps',
    config = function()
      vim.g.coq_settings = { auto_start = 'shut-up' }
    end
  }
  use {
    'neovim/nvim-lspconfig',
    requires = { { 'ms-jpq/coq_nvim' } },
    config = function()
      vim.api.nvim_set_keymap('n', '<C-]>', [[<CMD>lua vim.lsp.buf.definition()<CR>]], { noremap = true })
      vim.api.nvim_set_keymap('n', '<C-k>', [[<CMD>lua vim.lsp.buf.signature_help()<CR>]], { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>ca', [[<CMD>lua vim.lsp.buf.code_action()<CR>]], { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>dd', [[<CMD>lua vim.diagnostic.open_float()<CR>]], { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>j', [[<CMD> lua vim.lsp.buf.format()<CR>]], { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>rn', [[<CMD>lua vim.lsp.buf.rename()<CR>]], { noremap = true })
      vim.api.nvim_set_keymap('n', 'K', [[<CMD>lua vim.lsp.buf.hover()<CR>]], { noremap = true })
      vim.api.nvim_set_keymap('n', '[d', [[<CMD>lua vim.diagnostic.goto_prev()<CR>]], { noremap = true })
      vim.api.nvim_set_keymap('n', ']d', [[<CMD>lua vim.diagnostic.goto_next()<CR>]], { noremap = true })

      vim.diagnostic.config({ virtual_text = false })
      vim.o.updatetime = 250
      vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

      local coq = require('coq')
      local lspconfig = require('lspconfig')
      local servers = { 'angularls', 'lua_ls', 'tsserver' }
      for _, lsp in ipairs(servers) do
        local config = {}
        if (lsp == 'lua_ls') then
          config = {
            settings = {
              Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = { 'vim' } },
                workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                telemetry = { enable = false },
              },
            }
          }
        end
        lspconfig[lsp].setup(coq.lsp_ensure_capabilities(config))
      end
    end,
  }
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>hh', '<CMD>ColorizerToggle<CR>', { noremap = true })
    end,
  }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } },
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>fb', [[<CMD>lua require'telescope.builtin'.buffers()<CR>]],
        { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>fc', [[<CMD>lua require'telescope.builtin'.command_history()<CR>]],
        { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>fd', [[<CMD>lua require'telescope.builtin'.diagnostics()<CR>]],
        { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>ff', [[<CMD>lua require'telescope.builtin'.live_grep()<CR>]],
        { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>fh', [[<CMD>lua require'telescope.builtin'.oldfiles()<CR>]],
        { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>fp', [[<CMD>lua require'telescope.builtin'.find_files()<CR>]],
        { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>fr', [[<CMD>lua require'telescope.builtin'.lsp_references()<CR>]],
        { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>fs', [[<CMD>lua require'telescope.builtin'.lsp_document_symbols()<CR>]],
        { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>ft', [[<CMD>lua require'telescope.builtin'.colorscheme()<CR>]],
        { noremap = true })
    end,
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        context_commentstring = { enable = true },
        ensure_installed = {
          'bash',
          'css',
          'go',
          'html',
          'javascript',
          'json',
          'lua',
          'markdown',
          'python',
          'query',
          'ruby',
          'rust',
          'scss',
          'typescript',
          'yaml',
        },
        highlight = { enable = true },
        indent = { enable = false },
      })
    end,
  }
  use { 'tpope/vim-commentary' }
  use {
    'tpope/vim-fugitive',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>gs', ':Git<CR>', { noremap = true })
    end,
  }
  use { 'tpope/vim-repeat' }
  use { 'tpope/vim-sleuth' }
  use { 'tpope/vim-surround' }
  use { 'wbthomason/packer.nvim' }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
