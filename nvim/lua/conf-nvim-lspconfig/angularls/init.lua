local function get_config(on_attach)
    local ng_projects = os.getenv('HOME') .. '/src/raasdev/raas-ui'
    local ng_language_server = os.getenv('HOME') .. '/.nvm/versions/node/v12.13.1/lib/node_modules/@angular/language-server/index.js'
    local cmd = {'node', ng_language_server, '--stdio', '--tsProbeLocations', ng_projects, '--ngProbeLocations', ng_projects}

    return {
        on_attach = on_attach,
        cmd = cmd,
        on_new_config = function(new_config, new_root_dir)
            new_config.cmd = cmd
        end
    }
end

return {ls = 'angularls', lsp_status = false, get_config = get_config, references = false}
