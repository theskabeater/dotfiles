"https://github.com/erkrnt/awesome-streamerrc/blob/master/ThePrimeagen/init.vim
"vim
syntax on

set relativenumber
set hidden
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set cursorline
set nowrap
set smartcase
set noswapfile
set nobackup
set incsearch
set scrolloff=8
set cmdheight=2
set updatetime=100
set shortmess+=c
set colorcolumn=110
set signcolumn=yes:1
set noshowmode
set nohls
set diffopt=vertical

"cursor
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
    \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor

"plugins
call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'cakebaker/scss-syntax.vim'
Plug 'fatih/molokai'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/goyo.vim'
let g:goyo_width = 120
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'vim-utils/vim-man'

"coc
Plug 'iamcco/coc-angular'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tslint-plugin', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

call plug#end()

"lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'filename': 'LightlineFilename'
      \ },
      \ }
function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

"netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1

"keybinds
let mapleader="\<Space>"
nnoremap <leader><S-f> :Rg<space>
nnoremap <C-p> :GFiles<CR>
nnoremap <leader><Up>   :<C-u>silent! move-2<CR>==
nnoremap <leader><Down> :<C-u>silent! move+<CR>==
xnoremap <leader><Up>   :<C-u>silent! '<,'>move-2<CR>gv=gv
xnoremap <leader><Down> :<C-u>silent! '<,'>move'>+<CR>gv=gv
inoremap <expr> <c-space> coc#refresh()
nmap <leader>rr <Plug>(coc-rename)
nmap <leader>jj <Plug>(coc-definition)
nmap <leader>jr <Plug>(coc-references)
nmap <leader>jn <Plug>(coc-diagnostic-next)
nmap <leader>jp <Plug>(coc-diagnostic-prev)
nmap <leader>qf  <Plug>(coc-fix-current)

"theme
au ColorScheme molokai hi Normal ctermbg=None
let g:rehash256 = 1
colorscheme molokai

"autocomplete
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif
inoremap <silent><expr> <leader><space> coc#refresh()

"trim trailing white space
autocmd BufWritePre * %s/\s\+$//e
