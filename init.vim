""""" Plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'junegunn/goyo.vim'
Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-sneak'
Plug 'liuchengxu/vim-clap', {'do': ':Clap install-binary!'}
Plug 'mhinz/vim-startify'
Plug 'mhinz/vim-signify'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'

" themes
Plug 'morhetz/gruvbox'

" syntax highlighting
Plug 'inkarkat/vim-SyntaxRange'
Plug 'sheerun/vim-polyglot'

call plug#end()

""""" Vim settings
set mouse=a
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set cmdheight=2
set signcolumn=yes
set autoindent
set smartindent
set nowrap
set nu rnu
set nobackup
set nowritebackup
set noswapfile
set hidden
set incsearch
set noshowmode
set updatetime=100
set nohls
set diffopt=vertical
set smartcase
set ignorecase
set scrolloff=4
set shortmess+=c
set clipboard=unnamedplus

""""" Non-plugin keybinds
let mapleader = ' '

" change buffers
nmap <silent> [b :bn<cr>
nmap <silent> ]b :bp<cr>

" search in 'very magic mode' by default
nnoremap / /\v
vnoremap / /\v
nnoremap <silent> <leader>l :set hls! hlsearch?<cr>

" change directories, Glcd comes from tpope/vim-fugitive
nnoremap <leader>cc :pwd<cr>
nnoremap <leader>cd :cd %:h<cr>:pwd<cr>
nnoremap <leader>cp :Glcd<cr>

""""" Disable arrow keys
cnoremap <down> <nop>
cnoremap <left> <nop>
cnoremap <right> <nop>
cnoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
inoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
nnoremap <up> <nop>
vnoremap <down> <nop>
vnoremap <left> <nop>
vnoremap <right> <nop>
vnoremap <up> <nop>

""""" Format options (autocomment)
au BufEnter * set fo-=c fo-=r fo-=o
autocmd BufEnter * silent! lcd %:p:h

""""" Theme/syntax highlighting
fun! HighlightTemplateLiteral()
    if &ft == 'typescript'
        call SyntaxRange#Include('template: `', '`,', 'html', '')
        call SyntaxRange#Include('styles: \[\_s\{-}`', '`,', 'css', '')
        syntax match htmlArg contained "\[\zs.\{-}\ze\]\|\*\w\+"
    endif
endfun
augroup hi-template-literal
  au!
  autocmd BufEnter * call HighlightTemplateLiteral()
augroup END

if has('termguicolors')
  set termguicolors
endif
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

set background=dark
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection='0'
colorscheme gruvbox

""""" Statusline
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [
      \     [ 'mode', 'paste' ],
      \     [ 'fugitive', 'filename' ]
      \   ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightlineFugitive',
      \   'readonly': 'LightlineReadonly',
      \   'modified': 'LightlineModified',
      \   'filename': 'LightlineFilename'
      \ },
      \ 'separator': {
      \   'left': '',
      \   'right': ''
      \ },
      \ 'subseparator': {
      \   'left': '',
      \   'right': ''
      \ }
    \ }

" show modified buffer
function! LightlineModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunc

" file is readonly
function! LightlineReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return ""
  else
    return ""
  endif
endfunc

" git branch
function! LightlineFugitive()
  if &ft != 'dirvish' && exists("*fugitive#head")
    let branch = fugitive#head()
    return branch !=# '' ? ' '.branch : ''
  endif
  return ''
endfunc

" nicer filename
function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
       \ ('' != expand('%:t') ? expand('%:t') : &ft == 'dirvish' ? expand('%F') : '[No Name]') .
       \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunc

""""" Git
au FileType fugitive nnoremap <esc> :normal gq<cr>
nnoremap <leader>gd :Gdiffsplit<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gl :Glog<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gg :Git<space>
nnoremap <leader>gp :SignifyHunkDiff<cr>
nnoremap <leader>gu :SignifyHunkUndo<cr>

"""""" Matchit settings to match html tags with '%'
au FileType typescript let b:match_words  = '<\(\w\w*\):</\1,{:}'

""""" Dirvish
nnoremap <silent> <leader>o :Dirvish %<cr>
let g:dirvish_mode = ':sort ,^\v(.*[\/])|\ze,'
let g:loaded_netrwPlugin = 1
let g:dirvish_relative_paths = 1
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
au FileType dirvish nnoremap <silent> <buffer> <esc> :normal gq<cr>
au FileType dirvish nnoremap <silent> <buffer> <c-c> :normal gq<cr>
au FileType dirvish nnoremap <silent> <buffer> <c-[> :normal gq<cr>

""""" Sneak
let g:sneak#label = 1

""""" Clap
let s:save_cpo = &cpoptions
set cpoptions&vim
let s:palette = {}
let s:bg0 = {'ctermbg': '235', 'guibg': '#282828'}
let s:palette.display = s:bg0
let s:palette.input = s:bg0
let s:palette.preview = s:bg0
let s:palette.spinner = extend({'ctermfg': '142', 'guifg':'#b8bb26'}, s:bg0)
let s:palette.search_text = extend({'ctermfg': '229', 'guifg': '#fbf1c7'}, s:bg0)
let s:palette.selected = {'ctermbg': '241', 'guibg': '#665c54'}
let s:palette.current_selection = {'ctermbg': '241', 'guibg': '#665c54'}
let s:palette.selected_sign = {'ctermfg': '66', 'guifg': '#458588', 'cterm': 'bold'}
let s:palette.current_selection_sign = s:palette.selected_sign
let g:clap#themes#gruvbox#palette = s:palette
let &cpoptions = s:save_cpo
unlet s:save_cpo
let g:clap_theme = 'gruvbox'
let g:clap_enable_icon = 1
let g:clap_popup_border = 'rounded'
let g:clap_search_box_border_style = 'nil'
nnoremap <leader>d :exec 'Clap filer' expand('%:p:h')<cr>
nnoremap <leader>h :Clap history<cr>
nnoremap <leader>b :Clap buffers<cr>
nnoremap <leader>p :Clap gfiles<cr>
nnoremap <leader>h :Clap history<cr>
nnoremap <leader>f :Clap grep2<cr>
nnoremap <leader>p :Clap gfiles<cr>

""""" CoC
let g:coc_global_extensions = [
    \ 'coc-tsserver',
    \ 'coc-angular',
    \ 'coc-eslint',
    \ 'coc-prettier',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-yank' ]

" jump to diagnostics
nmap <silent> ]d <plug>(coc-diagnostic-prev)
nmap <silent> [d <plug>(coc-diagnostic-next)

" <tab> through autocomplete list
inoremap <expr><s-TAB> pumvisible() ? "\<c-p>" : "\<c-h>"
inoremap <silent><expr> <tab>
  \ pumvisible() ? "\<c-n>" :
  \ <sid>check_back_space() ? "\<tab>" :
  \ coc#refresh()

fun! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfun

" trigger autocomplete
inoremap <silent><expr> <c-space> coc#refresh()
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<c-y>" : "\<c-g>u\<cr>"
else
  inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
endif

" jump to code definition
nmap <silent> <c-]> <plug>(coc-definition)

" show references of word under cursor
nmap <silent> gr <plug>(coc-references)

" show documentation or type information of word under cursor
nnoremap <silent> K :call <sid>show_documentation()<cr>
fun! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfun

" quick fix
nmap <leader>qf  <plug>(coc-fix-current)

" prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile
nnoremap <leader>j :Prettier<cr>

" format selected
xmap <leader>= <plug>(coc-format-selected)
nmap <leader>= <plug>(coc-format-selected)

" rename across project
nmap <leader>rn <plug>(coc-rename)

" jest keybinds
command! -nargs=0 JestCurrent :call  CocAction('runCommand', 'jest.fileTest', ['%'])
command! -nargs=0 Jest :call  CocAction('runCommand', 'jest.projectTest')
nnoremap <leader>tt :call CocAction('runCommand', 'jest.singleTest')<cr>
nnoremap <leader>tf :JestCurrent<cr>
nnoremap <leader>ta :Jest<cr>

""""" Sneak
let g:sneak#use_ic_scs = 1

""""" Startify
nnoremap <silent>~ :Startify <cr>
au FileType startify nnoremap <silent> <esc> :normal q<cr>
let g:startify_list_order = ['files', 'bookmarks']
let g:startify_bookmarks =  [{'c': '~/src/dotfiles/init.vim'},
                            \{'ru': '~/src/raasdev/raas-ui'},
                            \{'rr': '~/src/raasdev/raas'},
                            \{'rd':'~/src/raasdev/raas-docker'},
                            \{'sa': '~/src/raasdev/salt'},
                            \{'dev': '~/src/raasdev'},
                            \{'dot': '~/src/dotfiles'}]

""""" Utils
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
au BufWritePre * :call TrimWhitespace()

"vim regex tester
nnoremap <f5> mryi":let @/ = @"<cr>`r

"get syntax groups under cursor
nnoremap <f6> :call SynStack()<cr>
fun! SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

