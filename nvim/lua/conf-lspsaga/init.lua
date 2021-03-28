-- Options
local config = {
  use_saga_diagnostic_sign = true,
  error_sign = '▶',
  warn_sign = '▶',
  hint_sign = '▶',
  infor_sign = '▶',
  dianostic_header_icon = '   ',
  code_action_icon = ' ',
  code_action_prompt = {
    enable = true,
    sign = true,
    sign_priority = 20,
    virtual_text = false,
  },
  finder_definition_icon = '  ',
  finder_reference_icon = '  ',
  max_preview_lines = 10,
  finder_action_keys = {open = 'o', vsplit = 's', split = 'i',quit = 'q', scroll_down = '<C-f>', scroll_up = '<C-b>'},
  code_action_keys = {quit = 'q', exec = '<CR>'},
  rename_action_keys = {quit = '<C-c>', exec = '<CR>'},
  definition_preview_icon = '  ',
  border_style = 1,
  rename_prompt_prefix = '➤',
}

vim.fn.sign_define('LspSagaLightBulb', {text = config.code_action_icon, texthl = 'LspDiagnosticsSignInformation'})
local lspsaga = require 'lspsaga'
lspsaga.init_lsp_saga(config)

-- Keybinds
vim.api.nvim_set_keymap('n', 'K', [[<Cmd> lua require'lspsaga.hover'.render_hover_doc()<CR>]], {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>', [[<Cmd> lua require'lspsaga.signaturehelp'.signature_help()<CR>]], {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<C-d>', [[<Cmd> lua require'lspsaga.action'.smart_scroll_with_saga(1)<CR>]], {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<C-u>', [[<Cmd> lua require'lspsaga.action'.smart_scroll_with_saga(-1)<CR>]], {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>pd', [[<Cmd> lua require'lspsaga.provider'.preview_definition()<CR>]], {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>rn', [[<Cmd> lua require'lspsaga.rename'.rename()<CR>]], {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '[d', [[<Cmd> lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>]], {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', ']d', [[<Cmd> lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>]], {silent = true, noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ca', [[<Cmd> lua require('lspsaga.codeaction').code_action()<CR>]], {silent = true, noremap = true})
vim.api.nvim_set_keymap('v', '<leader>ca', [[<Cmd> '<,'>lua require('lspsaga.codeaction').range_code_action()<CR>]], {silent = true, noremap = true})

