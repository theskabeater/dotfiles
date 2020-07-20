call plug#begin('~/.config/nvim/plugged')
Plug 'sainnhe/gruvbox-material'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sleuth'
Plug 'sheerun/vim-polyglot'
Plug 'jonsmithers/vim-html-template-literals'
Plug 'alvan/vim-closetag'
Plug 'justinmk/vim-sneak'
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'liuchengxu/vim-clap', {'do': ':Clap install-binary!'}
Plug 'airblade/vim-rooter'
call plug#end()

""""" Global
set mouse=a
set clipboard=unnamed
let mapleader = ' '
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent
set cmdheight=2
set signcolumn=yes
set nowrap
set nu rnu
set noswapfile
set nobackup
set hidden
set scrolloff=8
set incsearch
set noshowmode
set cursorline
nmap <silent> ]b :bn<cr>
nmap <silent> [b :bp<cr>
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()
set diffopt=vertical
set smartcase
set ignorecase
nnoremap / /\v
vnoremap / /\v
nnoremap <silent> <leader>l :set hls! hlsearch?<cr>

""""" Theme/syntax highlighting
if has('termguicolors')
  set termguicolors
endif
set background=dark
let g:airline_theme = 'gruvbox_material'
let g:gruvbox_material_background = 'hard'
let g:htl_all_templates = 1
colorscheme gruvbox-material

""""" Git
nnoremap <leader>gd :Gdiffsplit<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gl :Glog<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gg :Git<space>
autocmd FileType fugitive nnoremap <esc> :normal gq<cr>

"""""" Closetag
let g:closetag_shortcut = '<leader>>'
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.ts,*.tsx,*.js,*.jsx'

"""""" matchit
autocmd FileType typescript let b:match_words  = '<\(\w\w*\):</\1,{:}'

""""" Sneak
let g:sneak#label = 1

""""" Clap
let g:clap_theme = 'material_design_dark'
nnoremap <leader>b :Clap buffers<cr>
nnoremap <leader>h :Clap history<cr>
nnoremap <leader>p :Clap gfiles<cr>
nnoremap <leader>f :Clap grep<cr>

""""" CoC
set nobackup
set nowritebackup
set shortmess+=c
let g:coc_global_extensions = [
    \ 'coc-tsserver',
    \ 'coc-tslint-plugin',
    \ 'coc-angular',
    \ 'coc-prettier',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-yank' ]
nmap <silent> ]g <plug>(coc-diagnostic-prev)
nmap <silent> [g <plug>(coc-diagnostic-next)
inoremap <silent><expr> <tab>
  \ pumvisible() ? "\<c-n>" :
  \ <sid>check_back_space() ? "\<tab>" :
  \ coc#refresh()
inoremap <expr><s-TAB> pumvisible() ? "\<c-p>" : "\<c-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <c-space> coc#refresh()
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<c-y>" : "\<c-g>u\<cr>"
else
  inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
endif
nmap <silent> <c-]> <plug>(coc-definition)
nmap <silent> gr <plug>(coc-references)
nnoremap <silent> K :call <sid>show_documentation()<cr>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
nmap <leader>qf  <plug>(coc-fix-current)
command! -nargs=0 Prettier :CocCommand prettier.formatFile
xmap <leader>= <plug>(coc-format-selected)
nmap <leader>= <plug>(coc-format-selected)
nmap <leader>rn <plug>(coc-rename)

""""" Startify
nnoremap <silent>~ :Startify <cr>
autocmd FileType startify nnoremap <silent> <esc> :normal q<cr>
let g:startify_list_order = ['files', 'bookmarks']
let g:startify_bookmarks =  [{'c': '~/src/dotfiles/init.vim'},
                            \{'ru': '~/src/raasdev/raas-ui'},
                            \{'rr': '~/src/raasdev/raas'},
                            \{'rd':'~/src/raasdev/raas-docker'},
                            \{'s': '~/src/raasdev/salt'},
                            \{'w': '~/src/raasdev'},
                            \{'d': '~/src/dotfiles'}]

""""" Format options (autocomment)
au BufEnter * set fo-=c fo-=r fo-=o`

