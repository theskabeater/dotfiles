require 'nvim_utils'

_G.ska.set_gitsigns = function()
    if not _G.ska.gitsigns_set then
        _G.ska.gitsigns_set = true

        local gitsigns = require 'gitsigns'
        gitsigns.setup {
            signs = {
                add = {hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn'},
                change = {hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn'},
                delete = {hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn'},
                topdelete = {hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn'},
                changedelete = {hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn'}
            },
            numhl = false,
            linehl = false,
            keymaps = {
                noremap = true,
                buffer = true,
                ['n ]c'] = {expr = true, [[&diff ? ']c' : '<Cmd>lua require"gitsigns".next_hunk()<CR>']]},
                ['n [c'] = {expr = true, [[&diff ? '[c' : '<Cmd>lua require"gitsigns".prev_hunk()<CR>']]},
                ['n <leader>ga'] = '<Cmd>lua require"gitsigns".stage_hunk()<CR>',
                ['n <leader>gu'] = '<Cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
                ['n <leader>gr'] = '<Cmd>lua require"gitsigns".reset_hunk()<CR>',
                ['n <leader>gR'] = '<Cmd>lua require"gitsigns".reset_buffer()<CR>',
                ['n <leader>gp'] = '<Cmd>lua require"gitsigns".preview_hunk()<CR>',
                ['n <leader>gb'] = '<Cmd>lua require"gitsigns".blame_line()<CR>',
                ['o ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>',
                ['x ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>'
            },
            watch_index = {interval = 1000},
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil,
            use_decoration_api = true,
            use_internal_diff = true
        }
    end
end

nvim_create_augroups({set_gitsigns = {{'ColorScheme', '*', 'silent! lua _G.ska.set_gitsigns()'}}})
