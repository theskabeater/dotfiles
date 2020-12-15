"""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.config/nvim/plugged')

Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-dirvish'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'nvim-treesitter/nvim-treesitter-angular'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'mhinz/vim-signify'
" Plug 'steelsojka/tree-sitter-angular'
Plug 'suy/vim-context-commentstring'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'unblevable/quick-scope'

" themes
Plug 'sainnhe/gruvbox-material'

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
nmap <leader>bo :%bd\|e#\|bd#<cr>\|'"

" toggle search highlight
nnoremap <leader>l :set hls!<cr>

" change directories, Glcd comes from tpope/vim-fugitive
nnoremap <leader>cw :pwd<cr>
nnoremap <leader>cc :echo expand('%:p')<cr>
nnoremap <leader>cd :cd %:h<cr>:pwd<cr>
nnoremap <leader>cp :Glcd <bar>:pwd<cr>



"""""""""""""""""""""""""""""""""""""""
" Formatting
"""""""""""""""""""""""""""""""""""""""

" disable auto comments in comment block
aug disable-auto-commenting
    au!
    au BufEnter * set fo-=c fo-=r fo-=o
aug END



"""""""""""""""""""""""""""""""""""""""
" Appearance
"""""""""""""""""""""""""""""""""""""""

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=dark
set t_Co=256
let g:gruvbox_material_background = 'hard'
colorscheme gruvbox-material

" statusline
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
" Treesitter
"""""""""""""""""""""""""""""""""""""""

lua <<EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "typescript",
        "javascript",
        "jsdoc",
        "html",
        "css",
    },
    highlight = {
        enable = true,
        --use_languagetree = true,
    },
    indent = {
        enable = true,
    }
}
EOF



"""""""""""""""""""""""""""""""""""""""
" GIT
"""""""""""""""""""""""""""""""""""""""

" keybindings
nnoremap <leader>gd :Gdiffsplit<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gl :Glog<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gg :Git<space>
nnoremap <leader>gp :SignifyHunkDiff<cr>
nnoremap <leader>gu :SignifyHunkUndo<cr>

fun! GitBindings()
    nnoremap <leader>g :diffget //2<cr>
    nnoremap <leader>h :diffget //3<cr>
    nnoremap <buffer> <esc> :normal gq<cr>
endfun

aug git-bindings
    au!
    au FileType fugitive call GitBindings()
aug END



"""""""""""""""""""""""""""""""""""""""
" Matchit
"""""""""""""""""""""""""""""""""""""""

" match html tags in ts files
aug matchit-html-tags
    au!
    au FileType typescript let b:match_words  = '<\(\w\w*\):</\1,{:}'
aug END



"""""""""""""""""""""""""""""""""""""""
" Dirvish
"""""""""""""""""""""""""""""""""""""""

" default sorting
let g:dirvish_mode = ':sort ,^\v(.*[\/])|\ze,'

" keybindings
fun! DirvishBindings()
    nnoremap <buffer> <esc> :normal gq<cr>
    nnoremap <buffer> <c-c> :normal gq<cr>
    nnoremap <buffer> <c-[> :normal gq<cr>
endfun

aug dirvish-bindings
    au!
    au FileType dirvish call DirvishBindings()
aug END



"""""""""""""""""""""""""""""""""""""""
" FZF
"""""""""""""""""""""""""""""""""""""""

let $FZF_DEFAULT_OPTS="--preview 'bat' --preview-window 'bottom:60%' --layout reverse --margin=1,4"
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
nnoremap <leader>fm :Marks<cr>
vnoremap <leader>fv :call SearchVisualSelectionWithAg()<cr>
nnoremap <leader>ft :Colors<cr>



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

" show documentation or type information of word under cursor
nnoremap K :call <sid>show_documentation()<cr>
fun! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfun

" commands
com! -nargs=0 Prettier :CocCommand prettier.formatFile
com! -nargs=0 JestCurrent :call  CocAction('runCommand', 'jest.fileTest', ['%'])
com! -nargs=0 Jest :call  CocAction('runCommand', 'jest.projectTest')

" keybinds
nnoremap <leader>rw :CocSearch <C-R>=expand("<cword>")<cr><cr>
nnoremap <leader>tt :call CocAction('runCommand', 'jest.singleTest')<cr>
nnoremap <leader>tf :JestCurrent<cr>
nnoremap <leader>ta :Jest<cr>
nnoremap <leader>j :Prettier<cr>
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<c-h>"
inoremap <expr> <tab> pumvisible() ? "\<c-n>" : <sid>check_back_space() ? "\<tab>" : coc#refresh()
nmap ]d <plug>(coc-diagnostic-next)
nmap [d <plug>(coc-diagnostic-prev)
nmap <c-]> <plug>(coc-definition)
nmap <leader>a <plug>(coc-codeaction)
nmap <leader>d :CocDiagnostics<cr>
nmap <leader>= <plug>(coc-format-selected)
nmap <leader>rn <plug>(coc-rename)
nmap <leader>rr <plug>(coc-references)
nmap <leader>qf <plug>(coc-fix-current)



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
