local lsp = require 'lspconfig'

local prettier = {formatCommand = 'prettierd --stdin-filepath ${INPUT}', formatStdin = true}

lsp.efm.setup {
    root_markers = {'.git/'},
    on_attach = function(client, bufnr)
        print(client.name .. ' language server started')
        client.resolved_capabilities.document_formatting = true
        local opts = {noremap = true, silent = true}
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>j', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    end,
    init_options = {documentFormatting = true},
    filetypes = {'typescript', 'scss', 'sass', 'css', 'html', 'json', 'lua', 'python'},
    settings = {
        languages = {
            typescript = {
                prettier, {
                    lintCommand = 'eslint_d -f unix --stdin --stdin-filename ${INPUT}',
                    lintStdin = true,
                    lintFormats = {'%f:%l:%c: %m'},
                    lintIgnoreExitCode = true,
                    formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}',
                    formatStdin = true
                }
            },
            scss = {prettier},
            css = {prettier},
            sass = {prettier},
            html = {prettier},
            json = {prettier},
            lua = {
                {
                    formatCommand = 'lua-format -i --no-keep-simple-function-one-line --no-break-after-operator --column-limit=150 --break-after-table-lb --double-quote-to-single-quote',
                    formatStdin = true
                }
            },
            python = {{formatCommand = 'isort --quiet -', formatStdin = true}, {formatCommand = 'black --quiet -', formatStdin = true}}
        }
    }
}
