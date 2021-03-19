" docs
nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
nnoremap <silent> <C-k> <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>

" refactor
nnoremap <silent><leader>rn <cmd>lua require('lspsaga.rename').rename()<CR>

" definitions
nnoremap <silent> <leader>pd <cmd>lua require'lspsaga.provider'.preview_definition()<CR>

" diagnostics
nnoremap <silent> [d <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
nnoremap <silent> ]d <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>
nnoremap <silent> <leader>dd <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>

" code actions
nnoremap <silent> <leader>ca <cmd>lua require('lspsaga.codeaction').code_action()<CR>
vnoremap <silent> <leader>ca <cmd>'<,'>lua require('lspsaga.codeaction').range_code_action()<CR>
