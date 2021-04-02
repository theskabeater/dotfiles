local lsp = require 'lspconfig'

-- Global settings
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
  }
)

-- Language servers
require 'conf-nvim-lspconfig.tsserver'
require 'conf-nvim-lspconfig.angularls'
require 'conf-nvim-lspconfig.pyls'
require 'conf-nvim-lspconfig.efm'

-- Highlights
require 'conf-nvim-lspconfig.highlights'
