local lspfuzzy = require('lspfuzzy')

lspfuzzy.setup {
  on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true }
    vim.api.nvim_set_keymap(bufnr, 'n', '<leader>da', '<Cmd>LspDiagnostics ' .. bufnr .. '<CR>', opts)
  end,
}
