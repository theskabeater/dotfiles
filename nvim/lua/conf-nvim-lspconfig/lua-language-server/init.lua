local lsp = require 'lspconfig'
local system_name
if vim.fn.has('mac') == 1 then
    system_name = 'macOS'
elseif vim.fn.has('unix') == 1 then
    system_name = 'Linux'
elseif vim.fn.has('win32') == 1 then
    system_name = 'Windows'
else
    print('Unsupported system for sumneko')
end

local sumneko_root_path = os.getenv('HOME') .. '/src/lua-language-server'
local sumneko_binary = sumneko_root_path .. '/bin/' .. system_name .. '/lua-language-server'
local cmd = {sumneko_binary, '-E', sumneko_root_path .. '/main.lua'}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

lsp.sumneko_lua.setup {
    cmd = cmd,
    settings = {
        Lua = {
            runtime = {version = 'LuaJIT', path = runtime_path},
            diagnostics = {globals = {'vim'}},
            workspace = {library = vim.api.nvim_get_runtime_file('', true)}
        }
    },
    on_attach = function(client, bufnr)
        if client.config.flags then client.config.flags.allow_incremental_sync = true end
        client.resolved_capabilities.document_formatting = false
        print(client.name .. ' language server started')
        local opts = {noremap = true, silent = true}
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ss', '<Cmd> lua vim.lsp.buf.document_symbol()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rh', '<Cmd> lua _G.ska.document_highlight()<CR>', opts)
    end
}
