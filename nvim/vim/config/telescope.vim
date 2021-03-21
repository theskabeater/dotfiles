nnoremap <leader>fp <cmd>Telescope find_files<cr>
nnoremap <leader>ff <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fc <cmd>Telescope command_history<cr>
nnoremap <leader>fh <cmd>Telescope oldfiles<cr>
nnoremap <leader>fw :lua require('telescope.builtin').live_grep({ default_text=vim.fn.expand("<cword>") })<CR>

" LSP
nnoremap <leader>rr <cmd>Telescope lsp_references<cr>
nnoremap <leader>df <cmd>Telescope lsp_document_diagnostics<cr>
