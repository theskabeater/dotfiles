let g:dirvish_mode=':sort ,^\v(.*[\/])|\ze,'

" replace netrw
let g:loaded_netrwPlugin=1
com! -nargs=? -complete=dir Explore Dirvish <args>
com! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
com! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>

fun! DirvishBindings()
    nnoremap <silent><buffer> p <Plug>(dovish_copy)
    nnoremap <silent><buffer> P <Plug>(dovish_move)
    nnoremap <silent><buffer> <esc> :normal gq<cr>
    nnoremap <silent><buffer> <c-c> :normal gq<cr>
    nnoremap <silent><buffer> <c-[> :normal gq<cr>
endfun

aug dirvish-bindings
    au!
    au FileType dirvish call DirvishBindings()
aug END
