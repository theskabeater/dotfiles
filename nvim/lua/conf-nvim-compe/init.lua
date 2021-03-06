local compe = require 'compe'

vim.o.completeopt = 'menuone,noselect'

-- Options
compe.setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = 'enable',
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 0,
    documentation = true,
    source = {vsnip = {priority = 3}, nvim_lsp = {priority = 2}, buffer = {priority = 1}, nvim_lua = true, path = true}
}

-- Tab complete
local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t '<C-n>'
    elseif vim.fn.call('vsnip#available', {1}) == 1 then
        return t '<Plug>(vsnip-expand-or-jump)'
    elseif check_back_space() then
        return t '<Tab>'
    else
        return vim.fn['compe#complete']()
    end
end

_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t '<C-p>'
    elseif vim.fn.call('vsnip#jumpable', {-1}) == 1 then
        return t '<Plug>(vsnip-jump-prev)'
    else
        return t '<S-Tab>'
    end
end

-- Keybinds
vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', {expr = true})
vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', {expr = true})
vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
vim.api.nvim_set_keymap('i', '<C-Space>', 'compe#complete()', {silent = true, noremap = true, expr = true})
vim.api.nvim_set_keymap('i', '<CR>', [[compe#confirm('<CR>')]], {silent = true, noremap = true, expr = true})
vim.api.nvim_set_keymap('i', '<C-y>', [[compe#confirm('<C-y>')]], {silent = true, noremap = true, expr = true})
vim.api.nvim_set_keymap('i', '<C-e>', [[compe#confirm('<C-e>')]], {silent = true, noremap = true, expr = true})
vim.api.nvim_set_keymap('i', '<C-u>', [[compe#scroll({'delta': + 4)]], {silent = true, noremap = true, expr = true})
vim.api.nvim_set_keymap('i', '<C-d>', [[compe#scroll({'delta': - 4)]], {silent = true, noremap = true, expr = true})
