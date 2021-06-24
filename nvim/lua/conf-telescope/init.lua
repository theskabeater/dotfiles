local telescope = require'telescope'
local sorters = require'telescope.sorters'
local previewers = require'telescope.previewers'

-- Options
telescope.setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_position = "bottom",
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_defaults = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  sorters.get_fuzzy_file,
    file_ignore_patterns = { '.git/.*' },
    generic_sorter =  sorters.get_generic_fuzzy_sorter,
    shorten_path = true,
    winblend = 0,
    width = 0.75,
    preview_cutoff = 120,
    results_height = 1,
    results_width = 0.8,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = previewers.buffer_previewer_maker
  }
}

telescope.load_extension('fzy_native')

_G.ska.grep_string = function()
  local opts = require('telescope.themes').get_ivy()
  local cword = vim.fn.expand('<cword>')
  opts.search = cword
  require'telescope.builtin'.grep_string(opts)
end

-- Keybinds
vim.api.nvim_set_keymap('n', '<leader>fp', [[<Cmd> lua require'telescope.builtin'.find_files(require('telescope.themes').get_ivy())<CR>]], {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ff', [[<Cmd> lua require'telescope.builtin'.live_grep(require('telescope.themes').get_ivy())<CR>]], {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fb', [[<Cmd> lua require'telescope.builtin'.buffers(require('telescope.themes').get_ivy())<CR>]], {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fc', [[<Cmd> lua require'telescope.builtin'.command_history(require('telescope.themes').get_ivy())<CR>]], {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fh', [[<Cmd> lua require'telescope.builtin'.oldfiles(require('telescope.themes').get_ivy())<CR>]], {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fw', [[<Cmd> lua _G.ska.grep_string()<CR>]], {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fr', [[<Cmd> lua require'telescope.builtin'.lsp_references(require('telescope.themes').get_ivy())<CR>]], {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fd', [[<Cmd> lua require'telescope.builtin'.lsp_document_diagnostics(require('telescope.themes').get_ivy())<CR>]], {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fs', [[<Cmd> lua require'telescope.builtin'.lsp_document_symbols(require('telescope.themes').get_ivy())<CR>]], {silent = true, noremap = true})
