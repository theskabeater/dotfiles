nnoremap <leader>gd :Gdiffsplit<cr>
nnoremap <leader>gs :Gstatus<cr>

fun! GitBindings()
    nnoremap <silent><buffer> <esc> :normal gq<cr>
endfun

aug git-bindings
    au!
    au FileType fugitive call GitBindings()
aug END
