require 'nvim_utils'

nvim_create_augroups({
    disable_automatic_comment_insertion = {{'BufEnter', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'}},
    highlight_yank = {{'TextYankPost', '*', 'silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=300}'}},
    trim_white_space_on_save = {{'BufWritePre', '*', [[:%s/\s\+$//e]]}}
})
