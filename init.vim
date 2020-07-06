"""""""""""""""""""""""""""""""
" Startify
"""""""""""""""""""""""""""""""
let g:startify_list_order = ['bookmarks', 'files']
let g:startify_bookmarks = [ '~/src/raasdev/raas-ui',
                           \ '~/src/raasdev/raas',
                           \ '~/src/raasdev/raas-docker',
                           \ '~/src/raasdev/salt',
                           \ '~/dotfiles']

"""""""""""""""""""""""""""""""
" VIM
"""""""""""""""""""""""""""""""
let mapleader = " "
set mouse=a
map <silent><f2> :exec &nu==&rnu? "se nu!" : "se rnu!"<cr>

"""""""""""""""""""""""""""""""
" Buffers
"""""""""""""""""""""""""""""""
set updatetime=250
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
nnoremap <silent>]b :bn<cr>
nnoremap <silent>[b :bp<cr>
nnoremap <silent>~ :Startify <cr>

"""""""""""""""""""""""""""""""
" Terminal
"""""""""""""""""""""""""""""""
set termguicolors
tnoremap <c-[> <c-\><c-n>
tnoremap <esc> <c-\><c-n>
nnoremap <silent><leader>tv <c-w>v <c-w><c-w> <bar> :term<cr>
nnoremap <silent><leader>ts <c-w>s <c-w><c-w> <bar> :term<cr>
au TermOpen * setlocal nonu nornu
au TermOpen * startinsert

"""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

"""""CoC
Plug 'neoclide/coc.nvim'

""""" Git
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'aymericbeaumet/vim-symlink'
Plug 'tpope/vim-fugitive'

""""" Syntax highlighting
Plug 'leafgarland/typescript-vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'othree/html5.vim'
Plug 'jonsmithers/vim-html-template-literals'
Plug 'thaerkh/vim-indentguides'

""""" Themes
Plug 'gruvbox-community/gruvbox'

""""" Status bar
Plug 'vim-airline/vim-airline'

""""" Landing page
Plug 'mhinz/vim-startify'

""""" File explore
Plug 'justinmk/vim-dirvish'
Plug 'kristijanhusak/vim-dirvish-git'

""""" Search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

""""" Movements
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'

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
aug CursorLineOnlyInActiveWindow
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
aug END

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
nmap <silent><leader>gp <plug>(GitGutterPreviewHunk)
nmap <silent><leader>gs <plug>(GitGutterStageHunk)
nmap <silent><leader>gu <plug>(GitGutterUndoHunk)

                
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
fun! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfun
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
nmap <silent>]d <plug>(coc-diagnostic-next)"

""""" Code navigation
nmap <silent>gd <plug>(coc-definition)
nmap <silent>gy <plug>(coc-type-definition)
nmap <silent>gi <plug>(coc-implementation)
nmap <silent>gr <plug>(coc-references)

""""" Documentation
fun! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        exec 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfun
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
let g:loaded_netrwPlugin = 1
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
fun! DirvishConfig()
	if &ft == 'dirvish'
        setlocal nonu nornu
        nnoremap <silent><buffer><leader>b :exec 'normal gq'<cr>
        nnoremap <silent><buffer>t ddO<esc>:let @"=substitute(@", '\n', '', 'g')<cr>
            \:r ! find "<c-r>"" -maxdepth 1 -print0 \| xargs -0 ls -Fd<cr>
            \:silent! keeppatterns %s/\/\//\//g<cr>
            \:silent! keeppatterns %s/[^a-zA-Z0-9\/]$//g<cr>
            \:silent! keeppatterns g/^$/d<cr>:noh<cr>
	else
		nnoremap <silent><buffer><leader>b :Dirvish %<cr>
    endif
endfun
aug dirvish_config
	au!
	au FileType * call DirvishConfig()
aug END

"""""""""""""""""""""""""""""""
" Utils
"""""""""""""""""""""""""""""""
fun! SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
