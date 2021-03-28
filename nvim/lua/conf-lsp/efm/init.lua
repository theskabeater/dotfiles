local lsp = require 'lspconfig'

lsp.efm.setup {
  root_markers = {'.git/'},
  on_attach = function(client, bufnr)
    print(client.name .. ' language server started')
    client.resolved_capabilities.document_formatting = true
    local opts = {noremap=true, silent=true}
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>j', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)
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
          lintCommand = 'eslint_d -f unix --stdin --stdin-filename ${INPUT}',
          lintStdin = true,
          lintFormats = {'%f:%l:%c: %m'},
          lintIgnoreExitCode = true,
          formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}',
          formatStdin = true
        },
      },
    },
  },
  filetypes = {
    'typescript',
  },
}
