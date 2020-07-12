"""""""""""""""""""""""""""""""
" Startify
"""""""""""""""""""""""""""""""
let g:startify_list_order = ['files', 'bookmarks']
let g:startify_bookmarks =  [ '~/src/raasdev/raas-ui',
                            \ '~/src/raasdev/raas',
                            \ '~/src/raasdev/raas-docker',
                            \ '~/src/raasdev/salt',
                            \ '~/src/raasdev/',
                            \ '~/dotfiles']
nnoremap <silent>~ :Startify <cr>

"""""""""""""""""""""""""""""""
" VIM
"""""""""""""""""""""""""""""""
let mapleader = " "
set mouse=a
let g:highlightedyank_highlight_duration = 200
syntax on

"""""""""""""""""""""""""""""""
" Buffers
"""""""""""""""""""""""""""""""
set updatetime=250
set hidden
nnoremap <leader>h <c-w>h
nnoremap <leader>j <c-w>j
nnoremap <leader>k <c-w>k
nnoremap <leader>l <c-w>l
nnoremap <leader>w <c-w>w
nnoremap <leader>= <c-w>=
nnoremap <leader>s <c-w>s <c-w><c-w>
nnoremap <leader>v <c-w>v <c-w><c-w>
nnoremap <silent><leader><left> :vertical resize -5<cr>
nnoremap <silent><leader><right> :vertical resize +5<cr>
nnoremap <silent><leader><up> :resize -5<cr>
nnoremap <silent><leader><down> :resize +5<cr>
nnoremap <silent>]b :bn<cr>
nnoremap <silent>[b :bp<cr>

"""""""""""""""""""""""""""""""
" Terminal
"""""""""""""""""""""""""""""""
set termguicolors
tnoremap <c-[> <c-\><c-n>
tnoremap <esc> <c-\><c-n>
nnoremap <silent><leader>tv <c-w>v <c-w><c-w> <bar> :term<cr>
nnoremap <silent><leader>ts <c-w>s <c-w><c-w> <bar> :term<cr>
au TermOpen * setlocal nonu nornu | startinsert

"""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

""""" VIM
Plug 'machakann/vim-highlightedyank'
Plug 'vim-airline/vim-airline'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'

""""" Git
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'tpope/vim-fugitive'

""""" Code
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'neovim/nvim-lsp'
Plug 'cakebaker/scss-syntax.vim'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-commentary'
Plug 'thaerkh/vim-indentguides'

""""" Color schemes
Plug 'gruvbox-community/gruvbox'

""""" File explorer
Plug 'justinmk/vim-dirvish'
Plug 'kristijanhusak/vim-dirvish-git'

""""" Search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

"""""""""""""""""""""""""""""""
" Syntax highlighting
"""""""""""""""""""""""""""""""
lua <<EOF
require'nvim-treesitter.configs'.setup {
    highlight = {
    },
    ensure_installed = 'all'
}
EOF

"""""""""""""""""""""""""""""""
" Autoclose tag file types
"""""""""""""""""""""""""""""""
let g:closetag_shortcut = '<leader>>'
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.ts,*.tsx,*.js,*.jsx'

"""""""""""""""""""""""""""""""
" Line numbers
"""""""""""""""""""""""""""""""
set nu rnu

"""""""""""""""""""""""""""""""
" Tabs
"""""""""""""""""""""""""""""""
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

"""""""""""""""""""""""""""""""
" Linewrap
"""""""""""""""""""""""""""""""
set nowrap

"""""""""""""""""""""""""""""""
" Backup files
"""""""""""""""""""""""""""""""
set noswapfile
set nobackup

""""""""""""""""""""""""""""""
" Editor appearance
"""""""""""""""""""""""""""""""
set colorcolumn=110
set cursorline
set signcolumn=yes
set scrolloff=8
set shortmess+=c
set noshowmode
set cmdheight=2

""""" Cursor
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
    \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
aug cursor_line_active_window
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
aug end

""""" Color scheme
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = 0
colorscheme gruvbox
set background=dark

""""" Statusline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#ignore_bufadd_pat = '!'

"""""""""""""""""""""""""""""""
" Search
"""""""""""""""""""""""""""""""
set nohls
set ignorecase
set smartcase

""""" Search files
command! -bang -nargs=* GGrep
    \ call fzf#vim#grep(
    \   'git grep --line-number -- '.shellescape(<q-args>), 0,
    \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
nnoremap <silent><leader>f :GGrep<cr>
nnoremap <silent><leader>p :GFiles<cr>

"""""""""""""""""""""""""""""""
" Git
"""""""""""""""""""""""""""""""
set diffopt=vertical
let g:gitgutter_map_keys = 0
nmap [g <plug>(GitGutterPrevHunk)
nmap ]g <plug>(GitGutterNextHunk)
nmap <silent><leader>gp <plug>(GitGutterPreviewHunk)
nmap <silent><leader>gs <plug>(GitGutterStageHunk)
nmap <silent><leader>gu <plug>(GitGutterUndoHunk)

"""""""""""""""""""""""""""""""
" LSP
"""""""""""""""""""""""""""""""
lua <<EOF
    require'nvim_lsp'.tsserver.setup{}
EOF
nnoremap <silent> gd <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0 <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW <cmd>lua vim.lsp.buf.workspace_symbol()<CR>


"""""""""""""""""""""""""""""""
" File explorer
"""""""""""""""""""""""""""""""
let g:loaded_netrwPlugin = 1
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
fun! DirvishConfig()
	if &ft == 'dirvish'
        setlocal nonu nornu
        nnoremap <silent><buffer><leader>b :exec 'normal gq'<cr>
        nnoremap <silent><buffer>t ddO<esc>:let @"=substitute(@", '\n', '', 'g')<cr>
            \ :r ! find "<c-r>"" -maxdepth 1 -print0 \| xargs -0 ls -Fd<cr>
            \ :silent! keeppatterns %s/\/\//\//g<cr>
            \ :silent! keeppatterns %s/[^a-zA-Z0-9\/]$//g<cr>
            \ :silent! keeppatterns g/^$/d<cr>:noh<cr>
	else
		nnoremap <silent><buffer><leader>b :Dirvish %<cr>
    endif
endfun
aug dirvish_config
	au!
	au FileType * call DirvishConfig()
aug end

"""""""""""""""""""""""""""""""
" Utils
"""""""""""""""""""""""""""""""
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()
