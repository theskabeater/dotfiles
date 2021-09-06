local lsp_status = require 'lsp-status'
lsp_status.register_progress()

local function get_config(on_attach)
    local cmd = {os.getenv('HOME') .. '/.virtualenvs/pyls-pop/bin/pylsp', '--verbose', '--log-file', os.getenv('HOME') .. '/src/dev/log'}

    return {cmd = cmd, on_attach = on_attach, filetypes = {'python'}}
end

return {ls = 'pylsp', lsp_status = true, get_config = get_config, references = true}
