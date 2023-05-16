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
vim.api.nvim_set_keymap('n', '<C-l>', '<CMD>noh<CR>', {noremap = true})
vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = {'*'},
    callback = function()
        vim.highlight.on_yank({higroup = 'IncSearch', timeout = 300})
    end
})
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = {'*'},
    callback = function() vim.cmd([[:%s/\s\+$//e]]) end
})
vim.api.nvim_create_autocmd('VimLeave', {
    pattern = {'*'},
    callback = function()
        if vim.fn.executable('eslint_d') == 1 then
            vim.cmd('!eslint_d stop')
        end
    end
})
vim.cmd(
    [[set statusline=%<%f\ %h%m%r%{get(b:,'gitsigns_head','')}%=%-14.(%l,%c%V%)\ %P]])
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') ..
                             '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({
            'git', 'clone', '--depth', '1',
            'https://github.com/wbthomason/packer.nvim', install_path
        })
        vim.cmd('packadd packer.nvim')
        return true
    end
    return false
end
if vim.g.vscode then
    vim.api.nvim_set_keymap('n', '-',
                            [[<CMD>call VSCodeNotify('workbench.view.explorer')<CR>]],
                            {noremap = true})
    vim.api.nvim_set_keymap('n', '[b', '<CMD>Tabprevious<CR>', {noremap = true})
    vim.api.nvim_set_keymap('n', ']b', '<CMD>Tabnext<CR>', {noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>bd', '<CMD>Tabclose<CR>',
                            {noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>bo', '<CMD>Tabonly<CR>',
                            {noremap = true})
    vim.api.nvim_set_keymap('n', '<C-k>',
                            [[<CMD>call VSCodeNotify('editor.action.peekDefinition')<CR>]],
                            {noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>fb',
                            [[<CMD>call VSCodeNotify('workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup')<CR>]],
                            {noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>ff',
                            [[<CMD>call VSCodeNotify('workbench.action.findInFiles', { 'query': ''})<CR>]],
                            {noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>fh', '<CMD>Ex<CR>', {noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>fp',
                            [[<CMD>call VSCodeNotify('workbench.action.quickOpen')<CR>]],
                            {noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>fr',
                            [[<CMD>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>]],
                            {noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>fw',
                            [[<CMD>call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>]],
                            {noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>gs',
                            [[<CMD>call VSCodeNotify('workbench.scm.repositories.focus')<CR>]],
                            {noremap = true})
    vim.api.nvim_set_keymap('n', '<leader>j',
                            [[<CMD>call VSCodeNotify('editor.action.formatDocument')<CR>]],
                            {noremap = true})
else
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
end
local packer_bootstrap = ensure_packer()
return require('packer').startup(function(use)
    use {'JoosepAlviste/nvim-ts-context-commentstring', disable = vim.g.vscode}
    use {
        'elgiano/nvim-treesitter-angular',
        branch = 'topic/jsx-fix',
        disable = vim.g.vscode
    }
    use {
        'j-hui/fidget.nvim',
        disable = vim.g.vscode,
        config = function()
            if vim.g.vscode then return end
            require('fidget').setup({})
        end
    }
    use {
        'jose-elias-alvarez/null-ls.nvim',
        disable = vim.g.vscode,
        requires = {{'nvim-lua/plenary.nvim'}},
        config = function()
            if vim.g.vscode then return end
            local null_ls = require('null-ls')
            local source_config = {disabled_filetypes = {'fugitive', 'dirvish'}};
            local unpack = unpack or table.unpack;
            local eslint_d_config = {
                unpack(source_config),
                filetypes = {
                    'javascript', 'javascriptreact', 'json', 'jsonc',
                    'typescript', 'typescriptreact', 'vue'
                },
                condition = function(utils)
                    if string.match(vim.fn.getcwd(), 'node_modules') then
                        return false
                    end
                    return utils.root_has_file({
                        '.eslintrc.js', '.eslintrc.json', '.eslintrc.cjs'
                    })
                end
            };
            null_ls.setup({
                sources = {
                    null_ls.builtins.code_actions.eslint_d.with(eslint_d_config),
                    null_ls.builtins.diagnostics.eslint_d.with(eslint_d_config),
                    null_ls.builtins.formatting.eslint_d.with(eslint_d_config),
                    null_ls.builtins.formatting.lua_format.with(source_config)
                }
            })
        end
    }
    use {
        'junegunn/goyo.vim',
        disable = vim.g.vscode,
        config = function()
            if vim.g.vscode then return end
            vim.api.nvim_set_keymap('n', '<leader>gg', '<CMD>Goyo<CR>',
                                    {noremap = true})
        end
    }
    use {
        'justinmk/vim-dirvish',
        disable = vim.g.vscode,
        requires = {{'roginfarrer/vim-dirvish-dovish'}},
        config = function()
            if vim.g.vscode then return end
            vim.g.dirvish_mode = [[:sort ,^\v(.*[\/])|\ze,]]
            vim.api.nvim_exec(
                [[com! -nargs=? -complete=dir Explore Dirvish <args>]], false)
            vim.api.nvim_exec(
                [[com! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>]],
                false)
            vim.api.nvim_exec(
                [[com! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>]],
                false)
        end
    }
    use {
        'lewis6991/gitsigns.nvim',
        disable = vim.g.vscode,
        requires = {{'nvim-lua/plenary.nvim'}},
        config = function()
            if vim.g.vscode then return end
            require('gitsigns').setup({
                keymaps = {
                    noremap = true,
                    ['n ]c'] = {
                        expr = true,
                        [[&diff ? ']c' : '<CMD>lua require('gitsigns.actions').next_hunk()<CR>']]
                    },
                    ['n [c'] = {
                        expr = true,
                        [[&diff ? '[c' : '<CMD>lua require('gitsigns.actions').prev_hunk()<CR>']]
                    },
                    ['n <leader>gr'] = [[<CMD>lua require('gitsigns').reset_hunk()<CR>]],
                    ['v <leader>gr'] = [[<CMD>lua require('gitsigns').reset_hunk({vim.fn.line('.'), vim.fn.line('v')})<CR>]],
                    ['n <leader>gp'] = [[<CMD>lua require('gitsigns').preview_hunk()<CR>]],
                    ['n <leader>gb'] = '<CMD>Git blame<CR>'
                }
            })
        end
    }
    use {
        'moll/vim-bbye',
        disable = vim.g.vscode,
        config = function()
            if vim.g.vscode then return end
            vim.api.nvim_set_keymap('n', '<leader>bo',
                                    [[<CMD>lua for _, number in ipairs(vim.api.nvim_list_bufs()) do if number ~= vim.api.nvim_get_current_buf() then vim.cmd('Bdelete ' .. number) end end<CR>]],
                                    {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>bd', '<CMD>Bdelete<CR>',
                                    {noremap = true})
            vim.api.nvim_set_keymap('n', '[b', '<CMD>bp<CR>', {noremap = true})
            vim.api.nvim_set_keymap('n', ']b', '<CMD>bn<CR>', {noremap = true})
        end
    }
    use {
        'neovim/nvim-lspconfig',
        disable = vim.g.vscode,
        requires = {
            'hrsh7th/nvim-cmp',
            requires = {
                {'hrsh7th/cmp-buffer'}, {'hrsh7th/cmp-cmdline'},
                {'hrsh7th/cmp-nvim-lsp'}, {'hrsh7th/cmp-path'},
                {'hrsh7th/cmp-vsnip'}, {'hrsh7th/vim-vsnip'},
                {'johnpapa/vscode-angular-snippets'}
            },
            config = function()
                if vim.g.vscode then return end
                local cmp = require('cmp')
                local has_words_before = function()
                    unpack = unpack or table.unpack
                    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                    return col ~= 0 and
                               vim.api
                                   .nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(
                                   col, col):match('%s') == nil
                end
                local cmp_next = function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif vim.fn['vsnip#available'](1) == 1 then
                        vim.call('vsnip#expand')
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end

                end
                local cmp_prev = function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif vim.fn['vsnip#available'](-1) == 1 then
                        vim.call('vsnip#expand')
                    else
                        fallback()
                    end
                end
                cmp.setup({
                    snippet = {
                        expand = function(args)
                            vim.fn['vsnip#anonymous'](args.body)
                        end
                    },
                    mapping = cmp.mapping.preset.insert({
                        ['<C-Space>'] = cmp.mapping.complete(),
                        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                        ['<C-e>'] = cmp.mapping.abort(),
                        ['<C-f>'] = cmp.mapping.scroll_docs(4),
                        ['<C-n>'] = cmp.mapping(cmp_next, {'i', 's'}),
                        ['<C-p'] = cmp.mapping(cmp_prev, {'i', 's'}),
                        ['<CR>'] = cmp.mapping.confirm({select = true}),
                        ['<Up>'] = cmp.mapping(cmp_prev, {'i', 's'}),
                        ['<Down>'] = cmp.mapping(cmp_next, {'i', 's'}),
                        ['<Tab>'] = cmp.mapping(cmp_next, {'i', 's', 'c'}),
                        ['<S-Tab>'] = cmp.mapping(cmp_prev, {'i', 's', 'c'})
                    }),
                    sources = cmp.config.sources({
                        {name = 'nvim_lsp'}, {name = 'vsnip'}
                    }, {{name = 'buffer'}})
                })
                cmp.setup.cmdline({'/', '?'}, {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = {{name = 'buffer'}}
                })
                cmp.setup.cmdline(':', {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = cmp.config.sources({{name = 'path'}},
                                                 {{name = 'cmdline'}})
                })
            end
        },
        config = function()
            if vim.g.vscode then return end
            vim.api.nvim_set_keymap('n', '<C-]>',
                                    '<CMD>lua vim.lsp.buf.definition()<CR>',
                                    {noremap = true})
            vim.api.nvim_set_keymap('n', '<C-k>',
                                    '<CMD>lua vim.lsp.buf.signature_help()<CR>',
                                    {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>ca',
                                    '<CMD>lua vim.lsp.buf.code_action()<CR>',
                                    {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>dd',
                                    '<CMD>lua vim.diagnostic.open_float()<CR>',
                                    {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>j',
                                    '<CMD> lua vim.lsp.buf.format({async = true})<CR>',
                                    {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>rn',
                                    '<CMD>lua vim.lsp.buf.rename()<CR>',
                                    {noremap = true})
            vim.api.nvim_set_keymap('n', 'K',
                                    '<CMD>lua vim.lsp.buf.hover()<CR>',
                                    {noremap = true})
            vim.api.nvim_set_keymap('n', '[d',
                                    '<CMD>lua vim.diagnostic.goto_prev()<CR>',
                                    {noremap = true})
            vim.api.nvim_set_keymap('n', ']d',
                                    '<CMD>lua vim.diagnostic.goto_next()<CR>',
                                    {noremap = true})
            vim.diagnostic.config({virtual_text = false})
            local lspconfig = require('lspconfig')
            local servers = {'angularls', 'lua_ls', 'tsserver'}
            for _, lsp in ipairs(servers) do
                local config = {
                    capabilities = require('cmp_nvim_lsp').default_capabilities(),
                    on_attach = function(client)
                        client.config.flags.allow_incremental_sync = true
                        client.server_capabilities.semanticTokensProvider = nil
                        client.server_capabilities.documentFormattingProvider =
                            false
                    end
                }
                local cmd = lspconfig[lsp].document_config.default_config.cmd[1];
                local configurable = vim.fn.executable(cmd)
                if configurable == 1 then
                    if (lsp == 'lua_ls') then
                        config.settings = {
                            Lua = {
                                runtime = {version = 'LuaJIT'},
                                diagnostics = {globals = {'vim'}},
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file('',
                                                                            true)
                                },
                                telemetry = {enable = false}
                            }
                        }
                    elseif (lsp == 'tsserver') then
                        config.init_options = {
                            preferences = {
                                importModuleSpecifierPreference = 'relative'
                            }
                        }
                        configurable = vim.fn.filereadable(vim.fn.getcwd() ..
                                                               '/tsconfig.json')
                    elseif (lsp == 'angularls') then
                        configurable = vim.fn.filereadable(vim.fn.getcwd() ..
                                                               '/angular.json')
                    end
                    if configurable == 1 then
                        lspconfig[lsp].setup(config)
                    end
                end
            end

        end
    }
    use {
        'norcalli/nvim-colorizer.lua',
        disable = vim.g.vscode,
        config = function()
            if vim.g.vscode then return end
            vim.api.nvim_set_keymap('n', '<leader>hh',
                                    '<CMD>ColorizerToggle<CR>', {noremap = true})
        end
    }
    use {
        'notjedi/nvim-rooter.lua',
        disable = vim.g.vscode,
        config = function()
            if vim.g.vscode then return end
            require('nvim-rooter').setup {
                rooter_patterns = {
                    '.git', '.hg', '.svn', '.package.json', 'angular.json',
                    'tsconfig.json', 'project.json'
                },
                trigger_patterns = {'*'},
                manual = false
            }
        end
    }
    use {
        'nvim-telescope/telescope.nvim',
        disable = vim.g.vscode,
        requires = {
            {'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}, {
                'nvim-telescope/telescope-fzf-native.nvim',
                disable = vim.g.vscode,
                run = 'make'
            }
        },
        config = function()
            if vim.g.vscode then return end
            local telescope = require('telescope')
            telescope.setup()
            telescope.load_extension('fzf')
            vim.api.nvim_set_keymap('n', '<leader>fb',
                                    [[<CMD>lua require('telescope.builtin').buffers()<CR>]],
                                    {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>fc',
                                    [[<CMD>lua require('telescope.builtin').command_history()<CR>]],
                                    {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>fd',
                                    [[<CMD>lua require('telescope.builtin').diagnostics()<CR>]],
                                    {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>ff',
                                    [[<CMD>lua require('telescope.builtin').live_grep()<CR>]],
                                    {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>fh',
                                    [[<CMD>lua require('telescope.builtin').oldfiles()<CR>]],
                                    {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>fp',
                                    [[<CMD>lua require('telescope.builtin').find_files()<CR>]],
                                    {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>fr',
                                    [[<CMD>lua require('telescope.builtin').lsp_references()<CR>]],
                                    {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<leader>fs',
                                    [[<CMD>lua require('telescope.builtin').lsp_document_symbols()<CR>]],
                                    {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>ft',
                                    [[<CMD>lua require('telescope.builtin').colorscheme()<CR>]],
                                    {noremap = true})
            vim.api.nvim_set_keymap('n', '<leader>fw',
                                    [[<CMD>lua require('telescope.builtin').grep_string({default_text = vim.fn.expand('<cword>')})<CR>]],
                                    {noremap = true})
        end
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        disable = vim.g.vscode,
        run = ':TSUpdate',
        config = function()
            if vim.g.vscode then return end
            require('nvim-treesitter.configs').setup({
                context_commentstring = {enable = true},
                ensure_installed = {
                    'bash', 'css', 'go', 'html', 'javascript', 'json', 'lua',
                    'make', 'markdown', 'python', 'query', 'ruby', 'rust',
                    'scss', 'typescript', 'yaml'
                },
                highlight = {enable = true},
                indent = {enable = false}
            })
        end
    }
    use {
        'ellisonleao/gruvbox.nvim',
        disable = vim.g.vscode,
        config = function()
            if vim.g.vscode then return end
            vim.o.background = 'dark'
            require('gruvbox').setup({contrast = 'hard'})
            vim.cmd('colorscheme gruvbox')
        end
    }
    use {'tpope/vim-commentary', lazy = true, disable = vim.g.vscode}
    use {
        'tpope/vim-fugitive',
        disable = vim.g.vscode,
        config = function()
            if vim.g.vscode then return end
            vim.api.nvim_set_keymap('n', '<leader>gs', ':Git<CR>',
                                    {noremap = true})
        end
    }
    use {'tpope/vim-repeat'}
    use {'tpope/vim-sleuth'}
    use {'tpope/vim-surround'}
    use({
        'iamcco/markdown-preview.nvim',
        disable = vim.g.vscode,
        run = function() vim.fn['mkdp#util#install']() end
    })
    use {'wbthomason/packer.nvim'}
    if packer_bootstrap then require('packer').sync() end
end)
