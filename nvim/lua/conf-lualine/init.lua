local lualine = require 'lualine'
local lsp_status = require 'lsp-status'
lsp_status.register_progress()

lsp_status.config({
    kind_labels = {},
    current_function = true,
    diagnostics = true,
    indicator_separator = '=',
    component_separator = ' ',
    indicator_errors = 'E',
    indicator_warnings = 'W',
    indicator_info = 'I',
    indicator_hint = '?',
    indicator_ok = '✓',
    spinner_frames = {'⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷'},
    status_symbol = '',
    select_symbol = nil,
    update_interval = 100
})

local colors = {
    black = '#' .. vim.g.base16_gui00,
    darkestgray = '#' .. vim.g.base16_gui01,
    darkgray = '#' .. vim.g.base16_gui02,
    medgray = '#' .. vim.g.base16_gui03,
    gray = '#' .. vim.g.base16_gui04,
    lightergray = '#' .. vim.g.base16_gui05,
    lightestgray = '#' .. vim.g.base16_gui06,
    white = '#' .. vim.g.base16_gui07,
    red = '#' .. vim.g.base16_gui08,
    orange = '#' .. vim.g.base16_gui09,
    yellow = '#' .. vim.g.base16_gui0A,
    green = '#' .. vim.g.base16_gui0B,
    teal = '#' .. vim.g.base16_gui0C,
    blue = '#' .. vim.g.base16_gui0D,
    pink = '#' .. vim.g.base16_gui0E,
    brown = '#' .. vim.g.base16_gui0F
}

-- Options
lualine.setup {
    options = {
        icons_enabled = false,
        theme = {
            normal = {
                a = {bg = colors.green, fg = colors.black, gui = 'bold'},
                b = {bg = colors.darkgray, fg = colors.white},
                c = {bg = colors.darkestgray, fg = colors.lightergray}
            },
            insert = {
                a = {bg = colors.blue, fg = colors.black, gui = 'bold'},
                b = {bg = colors.darkgray, fg = colors.white},
                c = {bg = colors.lightestgray, fg = colors.black}
            },
            visual = {
                a = {bg = colors.yellow, fg = colors.black, gui = 'bold'},
                b = {bg = colors.darkgray, fg = colors.white},
                c = {bg = colors.lightestgray, fg = colors.black}
            },
            replace = {
                a = {bg = colors.red, fg = colors.black, gui = 'bold'},
                b = {bg = colors.darkgray, fg = colors.white},
                c = {bg = colors.lightestgray, fg = colors.black}
            },
            command = {
                a = {bg = colors.pink, fg = colors.black, gui = 'bold'},
                b = {bg = colors.darkgray, fg = colors.white},
                c = {bg = colors.lightestgray, fg = colors.black}
            },
            inactive = {
                a = {bg = colors.darkestgray, fg = colors.lightergray, gui = 'bold'},
                b = {bg = colors.darkgray, fg = colors.white},
                c = {bg = colors.darkestgray, fg = colors.darkgray}
            }
        },
        component_separators = {'', ''},
        section_separators = {'', ''},
        disabled_filetypes = {}
    },
    sections = {
        lualine_a = {{'mode', upper = true}},
        lualine_b = {{'branch', icon = ''}, {'diff'}},
        lualine_c = {
            {'filename', file_status = true, full_path = true}, function()
                if (vim.lsp.buf_get_clients()) then
                    return lsp_status.status()
                else
                    return ''
                end
            end
        },
        lualine_x = {'filetype'},
        lualine_y = {'ConflictedVersion', 'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {'ConflictedVersion'},
        lualine_z = {}
    },
    extensions = {'fzf', 'fugitive'}
}
