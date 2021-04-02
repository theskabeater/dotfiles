local lsp = require 'lspconfig'

lsp.pyls.setup {
  on_attach = function(client, bufnr)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    client.resolved_capabilities.document_formatting = false
    print(client.name .. ' language server started')
    local opts = {noremap=true, silent=true}
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  end,
}
