local lsp = require 'lspconfig'

-- Global settings
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
  }
)

-- Language servers
require 'conf-lsp.tsserver'
require 'conf-lsp.angularls'
require 'conf-lsp.efm'

-- Highlights
require 'conf-lsp.highlights'
