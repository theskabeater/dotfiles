require 'nvim_utils'

_G.ska.set_base16_lsp_diagnostics = function()
  if vim.g.base16colorspace == 256 then
    local base16_cterm03 = vim.g.base16_cterm03
    local base16_cterm05 = vim.g.base16_cterm05
    local base16_cterm08 = vim.g.base16_cterm08
    local base16_cterm09 = vim.g.base16_cterm09
    local base16_gui01 = vim.g.base16_gui01
    local base16_gui03 = vim.g.base16_gui03
    local base16_gui05 = vim.g.base16_gui05
    local base16_gui08 = vim.g.base16_gui08
    local base16_gui09 = vim.g.base16_gui09

    vim.fn.Base16hi('LspDiagnosticsDefaultError', base16_gui08, '', base16_cterm08, '', '', '')
    vim.fn.Base16hi('LspDiagnosticsDefaultWarning', base16_gui09, '', base16_cterm09, '', '', '')
    vim.fn.Base16hi('LspDiagnosticsDefaultInformation', base16_gui05, '', base16_cterm05, '', '', '')
    vim.fn.Base16hi('LspDiagnosticsDefaultHint', base16_gui03, '', base16_cterm03, '', '', '')
    vim.fn.Base16hi('LspDiagnosticsSignError', base16_gui08, base16_gui01, base16_cterm08, '', '', '')
    vim.fn.Base16hi('LspDiagnosticsSignWarning', base16_gui09, base16_gui01, base16_cterm09, '', '', '')
    vim.fn.Base16hi('LspDiagnosticsSignInformation', base16_gui05, base16_gui01, base16_cterm05, '', '', '')
    vim.fn.Base16hi('LspDiagnosticsSignHint', base16_gui03, base16_gui01, base16_cterm03, '', '', '')
  end
end


local autocmds = {
  base16_lsp_diagnostics = {
    {'ColorScheme', '*', 'silent! lua _G.ska.set_base16_lsp_diagnostics()'},
  },
}

nvim_create_augroups(autocmds)
