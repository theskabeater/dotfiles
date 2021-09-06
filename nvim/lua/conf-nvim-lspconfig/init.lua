local lsp = require 'lspconfig'
local lsp_status = require 'lsp-status'
lsp_status.register_progress()

local angularls_config = require 'conf-nvim-lspconfig.angularls'
local efmls_config = require 'conf-nvim-lspconfig.efm'
local luals_config = require 'conf-nvim-lspconfig.lua-language-server'
local pyls_config = require 'conf-nvim-lspconfig.pyls'
local tsserver_config = require 'conf-nvim-lspconfig.tsserver'
local ls_configs = {angularls_config, efmls_config, luals_config, pyls_config, tsserver_config}

-- Global settings
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {virtual_text = false})

-- Global utils
_G.ska.document_highlight = function()
    if not _G.ska.buf_highlight then _G.ska.buf_highlight = {} end

    local bufnr = vim.api.nvim_buf_get_number('%')
    _G.ska.buf_highlight[bufnr] = not _G.ska.buf_highlight[bufnr]

    if _G.ska.buf_highlight[bufnr] then
        vim.lsp.buf.document_highlight()
    else
        vim.lsp.buf.clear_references()
    end
end

-- Setup
for i, ls_config in ipairs(ls_configs) do
    local function on_attach(client, bufnr)
        -- Common
        if client.config.flags then client.config.flags.allow_incremental_sync = true end
        client.resolved_capabilities.document_formatting = false
        if ls_config.lsp_status then lsp_status.on_attach(client) end

        -- Keybinds
        local opts = {noremap = true, silent = true}
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ss', '<Cmd> lua vim.lsp.buf.document_symbol()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rh', '<Cmd> lua _G.ska.document_highlight()<CR>', opts)
        if ls_config.references then vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts) end
    end

    local config = ls_config.get_config(on_attach)
    config.capabilities = vim.tbl_extend('keep', config.capabilities or {}, lsp_status.capabilities)
    lsp[ls_config.ls].setup(config)
end

-- Highlights
require 'conf-nvim-lspconfig.highlights'
