local lsp_status = require 'lsp-status'
lsp_status.register_progress()

local function get_config(on_attach)
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

    return {
        cmd = cmd,
        on_attach = on_attach,
        settings = {
            Lua = {
                runtime = {version = 'LuaJIT', path = runtime_path},
                diagnostics = {globals = {'vim'}},
                workspace = {library = vim.api.nvim_get_runtime_file('', true), maxPreload = 2000, preloadFileSize = 1000}
            }
        }
    }
end

return {ls = 'sumneko_lua', lsp_status = true, get_config = get_config, references = true}
