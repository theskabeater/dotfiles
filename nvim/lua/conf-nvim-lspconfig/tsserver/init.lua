local lsp_status = require 'lsp-status'
lsp_status.register_progress()

local function serialize(table)
    local index = 1
    local holder = '{'
    while true do
        if type(table[index]) == 'function' then
            index = index + 1
        elseif type(table[index]) == 'table' then
            holder = holder .. serialize(table[index])
        elseif type(table[index]) == 'number' then
            holder = holder .. tostring(table[index])
        elseif type(table[index]) == 'string' then
            holder = holder .. '"' .. table[index] .. '"'
        elseif table[index] == nil then
            holder = holder .. 'nil'
        elseif type(table[index]) == 'boolean' then
            holder = holder .. (table[index] and 'true' or 'false')
        end
        if index + 1 > #table then break end
        holder = holder .. ','
        index = index + 1
    end
    return holder .. '}'
end

local function get_config(on_attach)
    return {
        handlers = {
            onBeginInstallTyping = function(event)
                print(event.eventId)
            end
        },
        on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            if false then
                local filename = '/Users/emoncada/lua.log'
                io.open(filename, 'w'):close()
                local file = io.open(filename, 'a')
                local function log(x, i)
                    for k, v in pairs(x) do
                        if not k then k = '(key empty)' end
                        if not v or not (type(v) == 'table') then
                            v = '(value empty)'
                        else
                            v = serialize(v)
                        end

                        local indents = ''
                        for i = 1, i do indents = indents .. ' ' end

                        local key = indents .. 'key: ' .. k;
                        local value = indents .. 'value: ' .. v;
                        file:write(key, '\n')
                        file:write(value, '\n')
                        file:write('', '\n')

                        if type(v) == 'table' then log(v, i + 4) end
                    end
                end
                log(client.resolved_capabilities, 0)

                file:close()
            end
        end,
        init_options = {preferences = {importModuleSpecifierPreference = 'relative'}},
        filetypes = {'typescript'}
    }
end

return {ls = 'tsserver', lsp_status = false, get_config = get_config, references = true}
