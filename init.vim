"""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.config/nvim/plugged')
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-dirvish'
Plug 'mhinz/vim-startify'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mhinz/vim-signify'
Plug 'suy/vim-context-commentstring'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'unblevable/quick-scope'

" themes
Plug 'morhetz/gruvbox'

" syntax highlighting
Plug 'inkarkat/vim-SyntaxRange'
Plug 'sheerun/vim-polyglot'

call plug#end()



"""""""""""""""""""""""""""""""""""""""
" Global settings
"""""""""""""""""""""""""""""""""""""""

set mouse=a
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set cmdheight=2
set signcolumn=yes
set autoindent
set smartindent
set signcolumn=yes
set nowrap
set nobackup
set nowritebackup
set noswapfile
set hidden
set incsearch
set inccommand=nosplit
set updatetime=100
set diffopt=vertical
set smartcase
set ignorecase
set shortmess+=c
set scrolloff=4
set clipboard=unnamedplus
set nohls
set foldmethod=indent
set nofoldenable
set cursorline
set number relativenumber

" reset terminal cursor upon exiting
au VimLeave * set guicursor=a:ver30-iCursor-blinkon0



"""""""""""""""""""""""""""""""""""""""
" Global keybindings
"""""""""""""""""""""""""""""""""""""""

let mapleader = ' '

" change buffers/tabs
nmap ]b :bn<cr>
nmap [b :bp<cr>
nmap ]t :tabn<cr>
nmap [t :tabp<cr>
nmap <leader>tc :tabc<cr>
nmap <leader>bd :bp <bar> bd#<cr>
nmap <leader>ba :%bd\|e#\|bd#<cr>\|'"

" toggle search highlight
nnoremap <leader>l :set hls!<cr>

" change directories, Glcd comes from tpope/vim-fugitive
nnoremap <leader>cw :pwd<cr>
nnoremap <leader>cc :echo expand('%:p')<cr>
nnoremap <leader>cd :cd %:h<cr>:pwd<cr>
nnoremap <leader>cp :Glcd <bar>:pwd<cr>

" when using `dd` in the quickfix list, remove the item from the quickfix list
function! RemoveQFItem()
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  execute curqfidx + 1 . "cfirst"
  :copen
endfunction
:command! RemoveQFItem :call RemoveQFItem()
autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>



"""""""""""""""""""""""""""""""""""""""
" Formatting
"""""""""""""""""""""""""""""""""""""""

" disable auto comments in comment block
au BufEnter * set fo-=c fo-=r fo-=o



"""""""""""""""""""""""""""""""""""""""
" Appearance
"""""""""""""""""""""""""""""""""""""""

fun! HighlightTemplateLiteral()
    if &ft == 'typescript'
        call SyntaxRange#Include('template: `', '`,', 'html', '')
        call SyntaxRange#Include('styles: \[\_s\{-}`', '`,\_s\{-}\]', 'css', '')
        syntax match htmlArg contained "\[\zs.\{-}\ze\]\|\*\w\+"
    endif
endfun
aug hi-template-literal
  au!
  autocmd BufEnter * call HighlightTemplateLiteral()
aug END

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=dark
set t_Co=256
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox

hi default link User1 Error
set statusline =
set statusline +=[%n]
set statusline +=\ %F
set statusline +=\ %1*%m%0*
set statusline +=\ %{coc#status()}%{get(b:,'coc_current_function','')}
set statusline +=\ %h
set statusline +=%r
set statusline +=%w
set statusline +=%=\ %(%l,%c%V%)\/\%-5L


"""""""""""""""""""""""""""""""""""""""
" Context commentstring
"""""""""""""""""""""""""""""""""""""""

fun! CommentTemplateLiteral()
    " context commentstring
    if exists('g:context#commentstring#table') && !exists('g:context#commentstring#table.typescript')
        let g:context#commentstring#table.typescript = {
            \ 'synIncludeHtml': '<!-- %s -->',
            \ 'synIncludeCss': '/* %s */'
            \ }
    endif
endfun

aug comment-template-literal
    au!
    autocmd FileType typescript call CommentTemplateLiteral()
aug END



"""""""""""""""""""""""""""""""""""""""
" GIT
"""""""""""""""""""""""""""""""""""""""

" keybindings
au FileType fugitive nnoremap <buffer> <esc> :normal gq<cr>
nnoremap <leader>gd :Gdiffsplit<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gl :Glog<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gg :Git<space>
nnoremap <leader>gp :SignifyHunkDiff<cr>
nnoremap <leader>gu :SignifyHunkUndo<cr>
nnoremap <leader>g :diffget //2<cr>
nnoremap <leader>h :diffget //3<cr>



"""""""""""""""""""""""""""""""""""""""
" Matchit
"""""""""""""""""""""""""""""""""""""""

" match html tags in ts files
au FileType typescript let b:match_words  = '<\(\w\w*\):</\1,{:}'



"""""""""""""""""""""""""""""""""""""""
" Dirvish
"""""""""""""""""""""""""""""""""""""""

" default sorting
let g:dirvish_mode = ':sort ,^\v(.*[\/])|\ze,'

" keybindings
au FileType dirvish nnoremap <buffer> <esc> :normal gq<cr>
au FileType dirvish nnoremap <buffer> <c-c> :normal gq<cr>
au FileType dirvish nnoremap <buffer> <c-[> :normal gq<cr>



"""""""""""""""""""""""""""""""""""""""
" FZF
"""""""""""""""""""""""""""""""""""""""

let $FZF_DEFAULT_OPTS="--preview-window 'bottom:60%' --layout reverse --margin=1,4"
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Ag settings
com! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

com! -bang -nargs=? -complete=dir Buffers
  \ call fzf#vim#buffers(<q-args>, fzf#vim#with_preview(), <bang>0)

com! -bang -nargs=* Hist call fzf#vim#history(fzf#vim#with_preview())

fun! SearchWordWithAg()
    execute 'Ag' expand('<cword>')
endfun

fun! SearchVisualSelectionWithAg() range
    let old_reg = getreg('"')
    let old_regtype = getregtype('"')
    let old_clipboard = &clipboard
    set clipboard&
    normal! ""gvy
    let selection = getreg('"')
    call setreg('"', old_reg, old_regtype)
    let &clipboard = old_clipboard
    execute 'Ag' selection
endfun

" keybindings
nnoremap <leader>fp :Files<cr>
nnoremap <leader>ff :Ag<cr>
nnoremap <leader>fh :Hist<cr>
nnoremap <leader>fc :Commands<cr>
nnoremap <leader>fo :BLines<cr>
nnoremap <leader>fl :Lines<cr>
nnoremap <leader>fb :Buffers<cr>
nnoremap <leader>fw :call SearchWordWithAg()<cr>
vnoremap <leader>fv :call SearchVisualSelectionWithAg()<cr>



"""""""""""""""""""""""""""""""""""""""
" Quickscope
"""""""""""""""""""""""""""""""""""""""

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']



"""""""""""""""""""""""""""""""""""""""
" CoC
"""""""""""""""""""""""""""""""""""""""

let g:coc_global_extensions = [
    \ 'coc-angular',
    \ 'coc-eslint',
    \ 'coc-html',
    \ 'coc-jest',
    \ 'coc-json',
    \ 'coc-prettier',
    \ 'coc-tsserver',
    \ 'coc-yank' ]

" diagnostics
nmap <leader>d :CocDiagnostics<cr>
nmap ]d <plug>(coc-diagnostic-next)
nmap [d <plug>(coc-diagnostic-prev)

" <tab> through autocomplete list
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<c-h>"
inoremap <expr> <tab>
  \ pumvisible() ? "\<c-n>" :
  \ <sid>check_back_space() ? "\<tab>" :
  \ coc#refresh()

fun! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfun

" trigger autocomplete
inoremap <expr> <c-space> coc#refresh()
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<c-y>" : "\<c-g>u\<cr>"
else
  inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
endif

" jump to code definition
nmap <c-]> <plug>(coc-definition)

" show references of word under cursor
nmap <leader>rr <plug>(coc-references)

" show documentation or type information of word under cursor
nnoremap K :call <sid>show_documentation()<cr>
fun! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfun

" quick fix
nmap <leader>qf <plug>(coc-fix-current)

" prettier
com! -nargs=0 Prettier :CocCommand prettier.formatFile
nnoremap <leader>j :Prettier<cr>

" format selected
xmap <leader>= <plug>(coc-format-selected)
nmap <leader>= <plug>(coc-format-selected)

" rename across project
nmap <leader>rn <plug>(coc-rename)

" jest keybinds
com! -nargs=0 JestCurrent :call  CocAction('runCommand', 'jest.fileTest', ['%'])
com! -nargs=0 Jest :call  CocAction('runCommand', 'jest.projectTest')
nnoremap <leader>tt :call CocAction('runCommand', 'jest.singleTest')<cr>
nnoremap <leader>tf :JestCurrent<cr>
nnoremap <leader>ta :Jest<cr>

" code actions
nmap <leader>a <plug>(coc-codeaction)



"""""""""""""""""""""""""""""""""""""""
" Startify
"""""""""""""""""""""""""""""""""""""""

" keybindings
nnoremap ~ :Startify <cr>
au FileType startify nnoremap <esc> :normal q<cr>
let g:startify_list_order = ['files', 'bookmarks']
let g:startify_bookmarks =  [{'ru': '~/src/raasdev/raas-ui'},
                            \{'rr': '~/src/raasdev/raas'},
                            \{'rd':'~/src/raasdev/raas-docker'},
                            \{'sa': '~/src/raasdev/salt'},
                            \{'con': '~/.config'},
                            \{'dev': '~/src'},
                            \{'dot': '~/src/dotfiles'},
                            \{'envs': '~/src/raasdev/envs'},
                            \{'raasdev': '~/src/raasdev'}]



"""""""""""""""""""""""""""""""""""""""
" Utils
"""""""""""""""""""""""""""""""""""""""

" trim whitespace on save
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
au BufWritePre * :call TrimWhitespace()

" vim regex tester
nnoremap <f5> mryi":let @/ = @"<cr>`r

" get syntax groups under cursor
nnoremap <f6> :call SynStack()<cr>
fun! SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfun
