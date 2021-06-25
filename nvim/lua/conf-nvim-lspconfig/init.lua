local lsp = require 'lspconfig'

-- Global settings
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {virtual_text = false})

-- Global utils
_G.ska.document_highlight = function()
    if not _G.ska.buf_highlight then _G.ska.buf_highlight = {} end

    bufnr = vim.api.nvim_buf_get_number('%')
    _G.ska.buf_highlight[bufnr] = not _G.ska.buf_highlight[bufnr]

    if _G.ska.buf_highlight[bufnr] then
        vim.lsp.buf.document_highlight()
    else
        vim.lsp.buf.clear_references()
    end
end

-- Language servers
require 'conf-nvim-lspconfig.tsserver'
require 'conf-nvim-lspconfig.angularls'
require 'conf-nvim-lspconfig.lua-language-server'
require 'conf-nvim-lspconfig.pyls'
require 'conf-nvim-lspconfig.efm'

-- Highlights
require 'conf-nvim-lspconfig.highlights'
