local lsp = require 'lspconfig'

local prettier = {
  formatCommand = 'prettierd --stdin-filepath ${INPUT}',
  formatStdin = true,
}

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
        prettier,
        {
          lintCommand = 'eslint_d -f unix --stdin --stdin-filename ${INPUT}',
          lintStdin = true,
          lintFormats = {'%f:%l:%c: %m'},
          lintIgnoreExitCode = true,
          formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}',
          formatStdin = true,
        },
      },
      scss = {
        prettier,
      },
      css = {
        prettier,
      },
      sass = {
        prettier,
      },
      html = {
        prettier,
      },
      json = {
        prettier,
      },
      python = {
        {
          formatCommand = 'isort --quiet -',
          formatStdin = true,
        },
        {
          formatCommand = 'black --quiet -',
          formatStdin = true,
        },
      }
    },
  },
  filetypes = {
    'typescript',
    'scss',
    'sass',
    'css',
    'html',
    'json',
    'python',
  },
}
