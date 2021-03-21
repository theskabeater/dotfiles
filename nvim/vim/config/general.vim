set mouse=a
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
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
set cursorline
set number relativenumber
set iskeyword+=@-@

let mapleader = ' '

" Disable auto comments in comment block
aug disable-auto-commenting
    au!
    au BufEnter * set fo-=c fo-=r fo-=o
aug END

" Trim whitespace on save
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
au BufWritePre * :call TrimWhitespace()

" Highlight text being ranked
aug HighlightYank
    au!
    au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=300}
aug END

" change buffers/tabs
nmap ]b :bn<cr>
nmap [b :bp<cr>
nmap ]t :tabn<cr>
nmap [t :tabp<cr>
nmap <leader>tc :tabc<cr>
nmap <leader>bd :bp <bar> bd#<cr>
nmap <leader>bo :%bd\|e#\|bd#<cr>\|'"

" change directories, Glcd comes from tpope/vim-fugitive
nnoremap <leader>cw :pwd<cr>
nnoremap <leader>cc :echo expand('%:p')<cr>
nnoremap <leader>cd :cd %:h<cr>:pwd<cr>
nnoremap <leader>cp :Glcd <bar>:pwd<cr>

