"""""""""""""""""""""""""""""""
" Startify
"""""""""""""""""""""""""""""""
let g:startify_list_order = ['bookmarks', 'files']
let g:startify_bookmarks = [ '~/.config/nvim/init.vim',
                           \ '~/src/raasdev/raas-ui',
                           \ '~/src/raasdev/raas',
                           \ '~/src/raasdev/raas-docker',
                           \ '~/src/raasdev/salt' ]

"""""""""""""""""""""""""""""""
" VIM
"""""""""""""""""""""""""""""""
let mapleader = " "
set mouse=a
set formatoptions-=cro

"""""""""""""""""""""""""""""""
" Buffers
"""""""""""""""""""""""""""""""
set hidden
set updatetime=100
nnoremap <silent><leader>o :%bd<bar>e#<bar>bd#<cr><bar>'"


"""""""""""""""""""""""""""""""
" Navigation
"""""""""""""""""""""""""""""""
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
nnoremap <silent>]b :bnext<cr>
nnoremap <silent>[b :bprevious<cr>
nnoremap <silent><c-h> q:
nnoremap <silent>~ :Startify <cr>

"""""""""""""""""""""""""""""""
" Terminal
"""""""""""""""""""""""""""""""
set termguicolors
tnoremap <c-[> <c-\><c-n>
tnoremap <esc> <c-\><c-n>
nnoremap <silent><leader>tv <c-w>v <c-w><c-w> <bar> :term<cr>
nnoremap <silent><leader>ts <c-w>s <c-w><c-w> <bar> :term<cr>
au TermOpen * setlocal nonumber norelativenumber
au TermOpen * startinsert

"""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

"""""CoC
Plug 'neoclide/coc.nvim'

""""" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

""""" Syntax highlighting
Plug 'leafgarland/typescript-vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'othree/html5.vim'
Plug 'jonsmithers/vim-html-template-literals'

""""" Themes
Plug 'gruvbox-community/gruvbox'

""""" Status bar
Plug 'vim-airline/vim-airline'

""""" Landing page
Plug 'mhinz/vim-startify'

""""" Editor appearance
Plug 'nathanaelkane/vim-indent-guides'

""""" File explorer
Plug 'justinmk/vim-dirvish'
Plug 'kristijanhusak/vim-dirvish-git'

""""" Search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

""""" Movements
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

""""" Autoclose tags
Plug 'alvan/vim-closetag'

""""" Comments
Plug 'tomtom/tcomment_vim'

call plug#end()

"""""""""""""""""""""""""""""""
" Syntax highlighting
"""""""""""""""""""""""""""""""
filetype on
syntax on
let g:htl_all_templates = 1
au FileType scss set iskeyword+=- 
autocmd BufEnter * :syntax sync fromstart

"""""""""""""""""""""""""""""""
" Autoclose tag file types
"""""""""""""""""""""""""""""""
let g:closetag_shortcut = '<leader>>'
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.ts,*.tsx,*.js,*.jsx'

"""""""""""""""""""""""""""""""
" Line numbers
"""""""""""""""""""""""""""""""
set relativenumber

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

""""" Theme
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

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
nmap gp <plug>(GitGutterPreviewHunk)
nmap gs <plug>(GitGutterStageHunk)
nmap gu <plug>(GitGutterUndoHunk)

                
"""""""""""""""""""""""""""""""
" CoC
" https://github.com/neoclide/coc.nvim
"""""""""""""""""""""""""""""""
let g:coc_global_extensions = [
    \ 'coc-tsserver', 
    \ 'coc-tslint-plugin', 
    \ 'coc-angular', 
    \ 'coc-prettier', 
    \ 'coc-html', 
    \ 'coc-json', 
    \ 'coc-yank' ]

""""" Trigger completion
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <expr> <silent><tab>
            \ pumvisible() ? "\<c-n>" :
            \ <sid>check_back_space() ? "\<tab>" :
            \ coc#refresh()

""""" Confirm completion
if exists('*complete_info')
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<c-y>" : "\<c-g>u\<cr>"
else
    inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
endif

""""" Diagnostics
nnoremap <silent><nowait> <leader>a :<c-u>CocList diagnostics<cr>
nmap <silent>[d <plug>(coc-diagnostic-prev)
nmap <silent>]d <plug>(coc-diagnostic-next)

""""" Code navigation
nmap <silent>gd <plug>(coc-definition)
nmap <silent>gy <plug>(coc-type-definition)
nmap <silent>gi <plug>(coc-implementation)
nmap <silent>gr <plug>(coc-references)

""""" Documentation
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction
nnoremap <silent>K :call <sid>show_documentation()<cr>

""""" Highlight references
au CursorHold * silent call CocActionAsync('highlight')

""""" Refactoring
nmap <silent><leader>rn <plug>(coc-rename)
nmap <silent><leader>rr :call coc#refresh()<cr>

""""" Formatting
xmap <silent><leader>qq  <plug>(coc-format-selected)
nmap <silent><leader>qq  <plug>(coc-format-selected)
nmap <silent><leader>qf  <plug>(coc-fix-current)
command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

""""" Code actions
""""" Example: `<leader>aap` for current paragraph
xmap <silent><leader>a  <plug>(coc-codeaction-selected)
nmap <silent><leader>a  <plug>(coc-codeaction-selected)
nmap <silent><leader>ac  <plug>(coc-codeaction)

"""""""""""""""""""""""""""""""
" Statusline
"""""""""""""""""""""""""""""""
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#ignore_bufadd_pat = '!'

"""""""""""""""""""""""""""""""
" File explorer
"""""""""""""""""""""""""""""""
map <expr> <silent><leader>b &ft == 'dirvish' ?
    \ ":bprev<cr>" :
    \ ":let @/=expand(\"%:t\") <bar> execute 'e' expand(\"%:h\") <bar> normal n<cr>"

"""""""""""""""""""""""""""""""
" Utils
"""""""""""""""""""""""""""""""
function! SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
