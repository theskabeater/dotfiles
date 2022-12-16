require 'nvim_utils'

-- GLOBALS
_G.ska = {}

-- PLUGINS
local packer = require('packer')
local use = packer.use
packer.startup(function()
    use {'JoosepAlviste/nvim-ts-context-commentstring'}
    use {'airblade/vim-rooter'}
    use {'elgiano/nvim-treesitter-angular', commit = '024f5fbcc6fab26aa5699cd632e02d0ae98c2314'}
    use {'ellisonleao/gruvbox.nvim'}
    use {'hrsh7th/cmp-buffer'}
    use {'hrsh7th/cmp-nvim-lsp'}
    use {'hrsh7th/cmp-vsnip'}
    use {'hrsh7th/nvim-cmp'}
    use {'hrsh7th/vim-vsnip'}
    use {'j-hui/fidget.nvim'}
    use {'junegunn/goyo.vim'}
    use {'justinmk/vim-dirvish'}
    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
    use {'moll/vim-bbye'}
    use {'neovim/nvim-lspconfig'}
    use {'norcalli/nvim-colorizer.lua'}
    use {'norcalli/nvim_utils'}
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
    use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}}
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use {'nvim-treesitter/playground', run = ':TSUpdate'}
    use {'roginfarrer/vim-dirvish-dovish'}
    use {'tpope/vim-commentary'}
    use {'tpope/vim-fugitive'}
    use {'tpope/vim-repeat'}
    use {'tpope/vim-sleuth'}
    use {'tpope/vim-surround'}
    use {'wbthomason/packer.nvim'}
end)

-- SETTINGS
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
vim.wo.signcolumn = 'yes'
nvim_create_augroups({
    disable_automatic_comment_insertion = {{'BufEnter', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'}},
    highlight_yank = {{'TextYankPost', '*', 'silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=300}'}},
    trim_white_space_on_save = {{'BufWritePre', '*', [[:%s/\s\+$//e]]}},
    cleanup_langservers = {{'VimLeave', '*', '!pkill eslint_d prettierd'}}
})

-- SEARCH
vim.api.nvim_set_keymap('n', '<C-l>', ':noh<CR>', {noremap = true, silent = true})

-- COLORSCHEME
vim.o.termguicolors = true
vim.o.background = 'dark'
require('gruvbox').setup({contrast = 'hard'})
vim.cmd('colorscheme gruvbox')

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
    vim.api.nvim_buf_del_keymap(0, '', 'p')
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
        ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'}),
        ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'}),
        ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'}),
        ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'}),
        ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})
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
        local prettier = {
            formatCommand = 'prettierd ${INPUT}',
            formatStdin = true,
            env = {string.format('PRETTIERD_DEFAULT_CONFIG=%s', vim.fn.expand('~/.config/nvim/utils/linter-config/.prettierrc.json'))}
        }
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
                client.server_capabilities.documentFormattingProvider = true
                local opts = {noremap = true, silent = true}
                vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>j', '<Cmd>lua vim.lsp.buf.format({async = true})<CR>', opts)
            end,
            init_options = {documentFormatting = true},
            filetypes = {'typescript', 'javascript', 'scss', 'sass', 'css', 'html', 'json', 'lua'},
            settings = {
                root_markers = {'.git', 'packge-lock.json', 'package.json'},
                languages = {
                    typescript = {prettier, eslint_d},
                    javascript = {prettier, eslint_d},
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
        local cmd = {os.getenv('HOME') .. '/.pyenv/shims/pylsp'}
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

for i, lsp_config in ipairs(ls_configs) do
    local function on_attach(client, bufnr)
        if client.config.flags then client.config.flags.allow_incremental_sync = true end
        client.server_capabilities.documentFormattingProvider = false
        local opts = {noremap = true, silent = true}
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>dd', '<Cmd>lua vim.diagnostic.open_float()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    end
    local config = lsp_config.get_config(on_attach)
    config['capabilites'] = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
    lsp[lsp_config.ls].setup(config)
end

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
        layout_config = {horizontal = {mirror = false, prompt_position = 'top'}, vertical = {mirror = false, prompt_position = 'top'}},
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
vim.api.nvim_set_keymap('n', '<leader>rr', [[<Cmd> lua require'telescope.builtin'.lsp_references(require('telescope.themes').get_ivy())<CR>]],
                        {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fd', [[<Cmd> lua require'telescope.builtin'.diagnostics(require('telescope.themes').get_ivy())<CR>]],
                        {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fs', [[<Cmd> lua require'telescope.builtin'.lsp_document_symbols(require('telescope.themes').get_ivy())<CR>]],
                        {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ft', [[<Cmd> lua require'telescope.builtin'.colorscheme(require('telescope.themes').get_ivy())<CR>]],
                        {silent = true, noremap = true})

-- FUGITIVE
vim.api.nvim_set_keymap('n', '<leader>gs', ':Git<CR>', {silent = true, noremap = true})

-- ROOTER
vim.g.rooter_patterns = {'.git', 'packge-lock.json', 'package.json'}

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

-- LSP Status
require'fidget'.setup {}

-- TREESITTER
local configs = require 'nvim-treesitter.configs'
configs.setup {
    ensure_installed = {
        'typescript', 'lua', 'python', 'json', 'scss', 'css', 'html', 'ruby', 'go', 'rust', 'javascript', 'markdown', 'yaml', 'bash', 'query'
    },
    highlight = {enable = true},
    indent = {enable = false},
    context_commentstring = {enable = true}
}
require'nvim-treesitter.configs'.setup {
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?'
        }
    }
}

-- COLORIZER
vim.api.nvim_set_keymap('n', '<leader>hh', '<CMD>ColorizerToggle<CR>', {noremap = true, silent = true})

-- Goyo
vim.api.nvim_set_keymap('n', '<leader>gg', '<CMD>Goyo<CR>', {noremap = true, silent = true})
