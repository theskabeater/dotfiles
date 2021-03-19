local lsp = require('lspconfig')

-- Typescript
lsp.tsserver.setup {
  on_attach = function(client, bufnr)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    client.resolved_capabilities.document_formatting = false
    print("'" .. client.name .. "' language server started")
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  end,
}

-- Angular
local ng_projects = '/Users/emoncada/src/raasdev/raas-ui'
local ng_language_server = '/Users/emoncada/.nvm/versions/node/v12.13.1/lib/node_modules/@angular/language-server/index.js'
local cmd = {
  'node',
  ng_language_server,
  '--stdio',
  '--tsProbeLocations',
  ng_projects,
  '--ngProbeLocations',
  ng_projects,
}
lsp.angularls.setup {
  on_attach = function(client, bufnr)
    print("'" .. client.name .. "' language server started")
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  end,
  cmd = cmd,
  on_new_config = function(new_config, new_root_dir)
    new_config.cmd = cmd
  end,
}


-- Formatting
lsp.efm.setup {
  root_markers = {'.git/'},
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = true
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>j', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end,
  init_options = {documentFormatting = true},
  settings = {
    languages = {
      typescript = {
        {
          formatCommand = 'prettier --stdin-filepath ${INPUT}',
          formatStdin = true
        },
        {
          lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
          lintStdin = true,
          lintFormats = {"%f:%l:%c: %m"},
          lintIgnoreExitCode = true,
          formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
          formatStdin = true
        },
      },
    },
  },
  filetypes = {
    'typescript',
  },
}


-- Diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
  }
)
