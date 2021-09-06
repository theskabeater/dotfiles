local telescope = require 'telescope'
local sorters = require 'telescope.sorters'
local previewers = require 'telescope.previewers'
local actions = require 'telescope.actions'

-- Options
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
        set_env = {['COLORTERM'] = 'truecolor'}, -- default = nil,
        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,

        -- Layout
        layout_strategy = 'horizontal',
        layout_config = {horizontal = {mirror = false}, vertical = {mirror = false}},

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = previewers.buffer_previewer_maker,

        -- qflist keybinds
        mappings = {
            i = {['<C-w>'] = actions.send_selected_to_qflist + actions.open_qflist},
            n = {['<C-w>'] = actions.send_selected_to_qflist + actions.open_qflist}
        },

        -- fzf settings
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = false, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = 'smart_case' -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    }
}

telescope.load_extension('fzf')

_G.ska.grep_string = function()
    local opts = require('telescope.themes').get_ivy()
    local cword = vim.fn.expand('<cword>')
    opts.search = cword
    require'telescope.builtin'.grep_string(opts)
end

-- Keybinds
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
vim.api.nvim_set_keymap('n', '<leader>ft', [[<Cmd> lua require'telescope.builtin'.colorscheme(require('telescope.themes').get_ivy())<CR>]],
                        {silent = true, noremap = true})
