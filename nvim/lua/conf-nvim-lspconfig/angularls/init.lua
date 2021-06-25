local lsp = require 'lspconfig'

local ng_projects = os.getenv('HOME') .. '/src/raasdev/raas-ui'
local ng_language_server = os.getenv('HOME') .. '/.nvm/versions/node/v12.13.1/lib/node_modules/@angular/language-server/index.js'
local cmd = {'node', ng_language_server, '--stdio', '--tsProbeLocations', ng_projects, '--ngProbeLocations', ng_projects}

lsp.angularls.setup {
    on_attach = function(client, bufnr)
        print(client.name .. ' language server started')
        local opts = {noremap = true, silent = true}
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ss', '<Cmd> lua vim.lsp.buf.document_symbol()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rh', '<Cmd> lua _G.ska.document_highlight()<CR>', opts)
    end,
    cmd = cmd,
    on_new_config = function(new_config, new_root_dir)
        new_config.cmd = cmd
    end
}
