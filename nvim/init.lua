require 'nvim_utils'

-- GLOBALS
_G.ska = {}

-- PLUGINS
local packer = require('packer')
local use = packer.use
packer.startup(function()
    use 'JoosepAlviste/nvim-ts-context-commentstring'
    use 'airblade/vim-rooter'
    use 'chriskempson/base16-vim'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/vim-vsnip'
    use 'justinmk/vim-dirvish'
    use 'moll/vim-bbye'
    use 'neovim/nvim-lspconfig'
    use 'norcalli/nvim_utils'
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/nvim-treesitter-angular'
    use 'nvim-treesitter/playground'
    use 'roginfarrer/vim-dirvish-dovish'
    use 'tpope/vim-commentary'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-repeat'
    use 'tpope/vim-sleuth'
    use 'tpope/vim-surround'
    use 'unblevable/quick-scope'
    use 'wbthomason/packer.nvim'
    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
    use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}}
end)

-- SETTINGS
vim.g.mapleader = ' '
vim.o.backup = false
vim.o.clipboard = 'unnamedplus'
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
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes'
vim.cmd('set nohls')
vim.cmd('set noswapfile')
nvim_create_augroups({
    disable_automatic_comment_insertion = {{'BufEnter', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'}},
    highlight_yank = {{'TextYankPost', '*', 'silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=300}'}},
    trim_white_space_on_save = {{'BufWritePre', '*', [[:%s/\s\+$//e]]}},
    cleanup_langservers = {{'VimLeave', '*', '!pkill eslint_d prettierd'}}
})

-- COLORSCHEME
vim.o.termguicolors = true
vim.g.base16colorspace = 256
vim.cmd('colorscheme base16-gruvbox-dark-pale')

-- CLOSE BUFFERS
_G.ska.close_all_but_current = function()
    local current = nvim.get_current_buf()
    local buffers = nvim.list_bufs()
    for _, number in ipairs(buffers) do if number ~= current then vim.cmd('Bdelete ' .. number) end end
end
vim.api.nvim_set_keymap('n', '<leader>bo', '<CMD>lua _G.ska.close_all_but_current()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>bd', '<CMD>Bdelete<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[b', '<CMD>bp<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', ']b', '<CMD>bn<CR>', {noremap = true, silent = true})

-- DIRVISH
vim.g.dirvish_mode = [[:sort ,^\v(.*[\/])|\ze,]]
vim.g.loaded_netrwPlugin = 1
vim.api.nvim_exec([[
com! -nargs=? -complete=dir Explore Dirvish <args>
com! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
com! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
]], false)
_G.ska.set_dirvish_settings = function()
    vim.cmd('setlocal bufhidden=wipe')
    vim.api.nvim_buf_del_keymap(0, '', 'p')
    vim.api.nvim_buf_set_keymap(0, '', 'p', '<Plug>(dovish_copy)', {silent = true, noremap = true})
    vim.api.nvim_buf_set_keymap(0, '', 'P', '<Plug>(dovish_move)', {silent = true, noremap = true})
    vim.api.nvim_buf_set_keymap(0, '', '<Esc>', ':normal gq<CR>', {silent = true, noremap = true})
    vim.api.nvim_buf_set_keymap(0, '', '<C-c>', ':normal gq<CR>', {silent = true, noremap = true})
    vim.api.nvim_buf_set_keymap(0, '', '<C-[>', ':normal gq<CR>', {silent = true, noremap = true})
end
nvim_create_augroups({set_dirvish_settings = {{'FileType', 'dirvish', 'silent! lua _G.ska.set_dirvish_settings()'}}})

-- LSP
vim.cmd('set completeopt=menu,menuone,noselect')
local cmp = require 'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
        end
    },
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<C-y>'] = cmp.config.disable,
        ['<CR>'] = cmp.mapping.confirm({select = true}),
        ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'}),
        ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})
    },
    sources = cmp.config.sources({{name = 'nvim_lsp'}}, {{name = 'buffer'}})
})
local lsp = require 'lspconfig'
local angularls_config = {
    ls = 'angularls',
    get_config = function(on_attach)
        return {on_attach = on_attach}
    end
}
local efmls_config = {
    ls = 'efm',
    get_config = function(on_attach)
        local prettier = {formatCommand = 'prettierd ${INPUT}', formatStdin = true}
        local eslint_d = {
            lintCommand = 'eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}',
            lintStdin = true,
            lintFormats = {'%f(%l,%c): %rror %m'},
            lintIgnoreExitCode = true,
            formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}',
            formatStdin = true
        }
        local lua_format = {
            formatCommand = 'lua-format -i --no-keep-simple-function-one-line --no-break-after-operator --column-limit=150 --break-after-table-lb --double-quote-to-single-quote',
            formatStdin = true
        }
        local isort = {formatCommand = 'isort --quiet -', formatStdin = true}
        local black = {formatCommand = 'black --quiet -', formatStdin = true}

        return {
            cmd = {'efm-langserver', '-q'},
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
                client.resolved_capabilities.document_formatting = true
                local opts = {noremap = true, silent = true}
                vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>j', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)
            end,
            init_options = {documentFormatting = true},
            filetypes = {'python', 'typescript', 'typescriptreact', 'scss', 'sass', 'css', 'html', 'json', 'lua'},
            settings = {
                root_markers = {'.git', 'packge-lock.json', 'package.json'},
                languages = {
                    typescript = {prettier, eslint_d},
                    typescriptreact = {prettier},
                    javascript = {prettier},
                    scss = {prettier},
                    css = {prettier},
                    sass = {prettier},
                    html = {prettier},
                    json = {prettier},
                    lua = {lua_format},
                    python = {isort, black}
                }
            }
        }
    end
}
local luals_config = {
    ls = 'sumneko_lua',
    get_config = function(on_attach)
        local system_name
        if vim.fn.has('mac') == 1 then
            system_name = 'macOS'
        elseif vim.fn.has('unix') == 1 then
            system_name = 'Linux'
        elseif vim.fn.has('win32') == 1 then
            system_name = 'Windows'
        else
            print('Unsupported system for sumneko')
        end
        local sumneko_root_path = os.getenv('HOME') .. '/src/lua-language-server'
        local sumneko_binary = sumneko_root_path .. '/bin/' .. system_name .. '/lua-language-server'
        local cmd = {sumneko_binary, '-E', sumneko_root_path .. '/main.lua'}
        local runtime_path = vim.split(package.path, ';')
        table.insert(runtime_path, 'lua/?.lua')
        table.insert(runtime_path, 'lua/?/init.lua')
        return {
            cmd = cmd,
            on_attach = on_attach,
            settings = {
                Lua = {
                    runtime = {version = 'LuaJIT', path = runtime_path},
                    diagnostics = {globals = {'vim'}},
                    workspace = {library = vim.api.nvim_get_runtime_file('', true), maxPreload = 2000, preloadFileSize = 1000}
                }
            }
        }
    end
}
local pyls_config = {
    ls = 'pylsp',
    get_config = function(on_attach)
        local cmd = {os.getenv('HOME') .. '/.virtualenvs/pyls-pop/bin/pylsp', '--verbose', '--log-file', os.getenv('HOME') .. '/src/dev/log'}
        return {cmd = cmd, on_attach = on_attach, filetypes = {'python'}}
    end
}
local tsserver_config = {
    ls = 'tsserver',
    get_config = function(on_attach)
        return {
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
            end,
            init_options = {preferences = {importModuleSpecifierPreference = 'relative'}},
            filetypes = {'typescript', 'typescriptreact'}
        }
    end
}
local ls_configs = {angularls_config, efmls_config, luals_config, pyls_config, tsserver_config}
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                                                                   {virtual_text = false, update_in_insert = false, underline = false})
_G.ska.document_highlight = function()
    if not _G.ska.buf_highlight then _G.ska.buf_highlight = {} end
    local bufnr = vim.api.nvim_buf_get_number('%')
    _G.ska.buf_highlight[bufnr] = not _G.ska.buf_highlight[bufnr]
    if _G.ska.buf_highlight[bufnr] then
        vim.lsp.buf.document_highlight()
    else
        vim.lsp.buf.clear_references()
    end
end
for i, lsp_config in ipairs(ls_configs) do
    local function on_attach(client, bufnr)
        if client.config.flags then client.config.flags.allow_incremental_sync = true end
        client.resolved_capabilities.document_formatting = false
        local opts = {noremap = true, silent = true}
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ss', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ii', '<Cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>oo', '<Cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rh', '<Cmd>lua _G.ska.document_highlight()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>dd', '<Cmd>lua vim.diagnostic.open_float()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    end
    local config = lsp_config.get_config(on_attach)
    config['capabilites'] = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    lsp[lsp_config.ls].setup(config)
end

-- QUICKSCOPE
vim.g.qs_highlight_on_keys = {'f', 'F', 't', 'T'}

-- TELESCOPE
local telescope = require 'telescope'
local sorters = require 'telescope.sorters'
local previewers = require 'telescope.previewers'
local actions = require 'telescope.actions'
telescope.setup {
    defaults = {
        vimgrep_arguments = {'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case'},
        prompt_prefix = '> ',
        selection_caret = '> ',
        entry_prefix = '  ',
        initial_mode = 'insert',
        selection_strategy = 'reset',
        sorting_strategy = 'descending',
        file_sorter = sorters.get_fuzzy_file,
        file_ignore_patterns = {'.git/.*'},
        generic_sorter = sorters.get_generic_fuzzy_sorter,
        path_display = {},
        winblend = 0,
        border = {},
        borderchars = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'},
        color_devicons = true,
        use_less = true,
        set_env = {['COLORTERM'] = 'truecolor'},
        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,
        layout_strategy = 'horizontal',
        layout_config = {horizontal = {mirror = false}, vertical = {mirror = false}},
        buffer_previewer_maker = previewers.buffer_previewer_maker,
        mappings = {
            i = {
                ['<C-w>'] = actions.send_selected_to_qflist + actions.open_qflist,
                ['<Down>'] = actions.cycle_history_next,
                ['<Up>'] = actions.cycle_history_prev
            },
            n = {['<C-w>'] = actions.send_selected_to_qflist + actions.open_qflist}

        },
        fzf = {fuzzy = true, override_generic_sorter = false, override_file_sorter = true, case_mode = 'smart_case'},
        wrap_results = true
    }
}
telescope.load_extension('fzf')
_G.ska.grep_string = function()
    local opts = require('telescope.themes').get_ivy()
    local cword = vim.fn.expand('<cword>')
    opts.search = cword
    require'telescope.builtin'.grep_string(opts)
end
vim.api.nvim_set_keymap('n', '<leader>fp', [[<Cmd> lua require'telescope.builtin'.find_files(require('telescope.themes').get_ivy())<CR>]],
                        {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ff', [[<Cmd> lua require'telescope.builtin'.live_grep(require('telescope.themes').get_ivy())<CR>]],
                        {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fb', [[<Cmd> lua require'telescope.builtin'.buffers(require('telescope.themes').get_ivy())<CR>]],
                        {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fc', [[<Cmd> lua require'telescope.builtin'.command_history(require('telescope.themes').get_ivy())<CR>]],
                        {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fh', [[<Cmd> lua require'telescope.builtin'.oldfiles(require('telescope.themes').get_ivy())<CR>]],
                        {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fw', [[<Cmd> lua _G.ska.grep_string()<CR>]], {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fr', [[<Cmd> lua require'telescope.builtin'.lsp_references(require('telescope.themes').get_ivy())<CR>]],
                        {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fd',
                        [[<Cmd> lua require'telescope.builtin'.lsp_document_diagnostics(require('telescope.themes').get_ivy())<CR>]],
                        {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fs', [[<Cmd> lua require'telescope.builtin'.lsp_document_symbols(require('telescope.themes').get_ivy())<CR>]],
                        {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fa', [[<Cmd> lua require'telescope.builtin'.lsp_code_actions(require('telescope.themes').get_ivy())<CR>]],
                        {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ft', [[<Cmd> lua require'telescope.builtin'.colorscheme(require('telescope.themes').get_ivy())<CR>]],
                        {silent = true, noremap = true})

-- FUGITIVE
vim.api.nvim_set_keymap('n', '<leader>gs', ':Git<CR>', {silent = true, noremap = true})
_G.ska.set_vim_fugitive_keybinds = function()
    -- vim.api.nvim_buf_set_keymap(0, '', '<Esc>', ':normal gq<CR>', {silent = true, noremap = true})
    vim.api.nvim_buf_set_keymap(0, '', '<C-c>', ':normal gq<CR>', {silent = true, noremap = true})
    vim.api.nvim_buf_set_keymap(0, '', '<C-[>', ':normal gq<CR>', {silent = true, noremap = true})
end
nvim_create_augroups({vim_fugitive_keybinds = {{'FileType', 'fugitive', 'silent! lua _G.ska.set_vim_fugitive_keybinds()'}}})

-- ROOTER
vim.g.rooter_patterns = {'.git', 'packge-lock.json', 'package.json'}

-- HIGHLIGHTS
_G.ska.set_base16_lsp_diagnostics = function()
    if not _G.ska.base16_lsp_diagnostics_set then
        _G.ska.set_base16_lsp_diagnostics_set = true
        local base16_cterm01 = vim.g.base16_cterm01
        local base16_cterm03 = vim.g.base16_cterm03
        local base16_cterm05 = vim.g.base16_cterm05
        local base16_cterm08 = vim.g.base16_cterm08
        local base16_cterm09 = vim.g.base16_cterm09
        local base16_cterm0A = vim.g.base16_cterm0A
        local base16_gui01 = vim.g.base16_gui01
        local base16_gui03 = vim.g.base16_gui03
        local base16_gui05 = vim.g.base16_gui05
        local base16_gui08 = vim.g.base16_gui08
        local base16_gui09 = vim.g.base16_gui09
        local base16_gui0A = vim.g.base16_gui0A
        vim.fn.Base16hi('LspDiagnosticsDefaultError', base16_gui08, '', base16_cterm08, '', '', '')
        vim.fn.Base16hi('DiagnosticError', base16_gui08, '', base16_cterm08, '', '', '')
        vim.fn.Base16hi('LspDiagnosticsDefaultWarning', base16_gui09, '', base16_cterm09, '', '', '')
        vim.fn.Base16hi('DiagnosticWarn', base16_gui09, '', base16_cterm09, '', '', '')
        vim.fn.Base16hi('LspDiagnosticsDefaultInformation', base16_gui05, '', base16_cterm05, '', '', '')
        vim.fn.Base16hi('DiagnosticInfo', base16_gui05, '', base16_cterm05, '', '', '')
        vim.fn.Base16hi('LspDiagnosticsDefaultHint', base16_gui03, '', base16_cterm03, '', '', '')
        vim.fn.Base16hi('DiagnosticHint', base16_gui03, '', base16_cterm03, '', '', '')
        vim.fn.Base16hi('LspDiagnosticsSignError', base16_gui08, base16_gui01, base16_cterm08, '', '', '')
        vim.fn.Base16hi('DiagnosticSignError', base16_gui08, base16_gui01, base16_cterm08, '', '', '')
        vim.fn.Base16hi('LspDiagnosticsSignWarning', base16_gui09, base16_gui01, base16_cterm09, '', '', '')
        vim.fn.Base16hi('DiagnosticSignWarn', base16_gui09, base16_gui01, base16_cterm09, '', '', '')
        vim.fn.Base16hi('LspDiagnosticsSignInformation', base16_gui05, base16_gui01, base16_cterm05, '', '', '')
        vim.fn.Base16hi('DiagnosticSignInfo', base16_gui05, base16_gui01, base16_cterm05, '', '', '')
        vim.fn.Base16hi('LspDiagnosticsSignHint', base16_gui03, base16_gui01, base16_cterm03, '', '', '')
        vim.fn.Base16hi('DiagnosticSignHint', base16_gui03, base16_gui01, base16_cterm03, '', '', '')
        vim.fn.Base16hi('LspReferenceText', base16_gui01, base16_gui0A, base16_cterm01, base16_cterm0A, '', '')
        vim.fn.Base16hi('ReferenceText', base16_gui01, base16_gui0A, base16_cterm01, base16_cterm0A, '', '')
        vim.fn.Base16hi('LspReferenceRead', base16_gui01, base16_gui0A, base16_cterm01, base16_cterm0A, '', '')
        vim.fn.Base16hi('ReferenceRead', base16_gui01, base16_gui0A, base16_cterm01, base16_cterm0A, '', '')
        vim.fn.Base16hi('LspReferenceWrite', base16_gui01, base16_gui0A, base16_cterm01, base16_cterm0A, '', '')
        vim.fn.Base16hi('ReferenceWrite', base16_gui01, base16_gui0A, base16_cterm01, base16_cterm0A, '', '')
    end
end
nvim_create_augroups({set_base16_lsp_diagnostics = {{'Syntax', '*', 'silent! lua _G.ska.set_base16_lsp_diagnostics()'}}})

-- GITSIGNS
local gitsigns = require 'gitsigns'
gitsigns.setup {
    keymaps = {
        noremap = true,
        ['n ]c'] = {expr = true, '&diff ? \']c\' : \'<cmd>lua require"gitsigns.actions".next_hunk()<CR>\''},
        ['n [c'] = {expr = true, '&diff ? \'[c\' : \'<cmd>lua require"gitsigns.actions".prev_hunk()<CR>\''},
        ['n <leader>gr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
        ['v <leader>gr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
        ['n <leader>gp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
        ['n <leader>gb'] = '<cmd>Git blame<CR>'
    }
}

-- STATUSLINE
vim.cmd([[
set statusline=%<%f\ %h%m%r%{get(b:,'gitsigns_head','')}%=%-14.(%l,%c%V%)\ %P
]])

-- TREESITTER
local configs = require 'nvim-treesitter.configs'
configs.setup {
    ensure_installed = 'all',
    ignore_install = {'comment', 'jsdoc', 'JSON with comments'},
    highlight = {enable = true},
    incremental_selection = {
        enable = true,
        keymaps = {init_selection = 'gnn', node_incremental = 'grn', scope_incremental = 'grc', node_decremental = 'grm'}
    },
    indent = {enable = false},
    context_commentstring = {enable = true}
}

