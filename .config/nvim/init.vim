" Bookmarks
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

"""""""""""""""""""""""""""""""
" Navigation
"""""""""""""""""""""""""""""""
set mouse=a
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <leader>o <C-w>o
nnoremap <leader>= <C-w>=
nnoremap <leader>s <C-w>s
nnoremap <leader>v <C-w>v
nnoremap <leader><left> :vertical resize -5<CR>
nnoremap <leader><right> :vertical resize +5<CR>
nnoremap <leader><up> :resize -5<CR>
nnoremap <leader><down> :resize +5<CR>
nnoremap <leader>t :new term://bash<CR>
nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprevious<CR>
nnoremap <C-h> q:
nnoremap ~ :Startify <CR>

"""""""""""""""""""""""""""""""
" Terminal
"""""""""""""""""""""""""""""""
au TermOpen * setlocal nonumber norelativenumber
tnoremap <Esc> <C-\><C-n>
tnoremap <C-[> <C-\><C-n>
set termguicolors

"""""""""""""""""""""""""""""""
" Plugins
" https://github.com/junegunn/vim-plug
"""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

""""" LSP
Plug 'neoclide/coc.nvim'

""""" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

""""" Syntax highlighting
Plug 'leafgarland/typescript-vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'othree/html5.vim'
Plug 'Quramy/vim-js-pretty-template'

""""" Themes
Plug 'gruvbox-community/gruvbox'

""""" Status bar
Plug 'vim-airline/vim-airline'

""""" Landing page
Plug 'mhinz/vim-startify'

""""" Editor appearance
Plug 'nathanaelkane/vim-indent-guides'

""""" File explorer
Plug 'mcchrish/nnn.vim'

""""" Search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

""""" Movements
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

""""" Autoclose tags
Plug 'alvan/vim-closetag'


call plug#end()

"""""""""""""""""""""""""""""""
" Syntax highlighting
"""""""""""""""""""""""""""""""
syntax on
autocmd FileType scss set iskeyword+=-
function! RefreshSyntaxHighlighting()
    if (&filetype == 'typescript')
        call jspretmpl#register_tag('template:\s', 'html')
        JsPreTmpl
        syn clear foldBraces
    endif
    syn sync fromstart
endfunction
autocmd  BufEnter * call RefreshSyntaxHighlighting()


"""""""""""""""""""""""""""""""
" Autoclose tag file types
"""""""""""""""""""""""""""""""
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.ts,*.tsx,*.js,*.jsx'

"""""""""""""""""""""""""""""""
" Line numbers
"""""""""""""""""""""""""""""""
set relativenumber

"""""""""""""""""""""""""""""""
" Buffers
"""""""""""""""""""""""""""""""
set hidden
set updatetime=100

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

"""""""""""""""""""""""""""""""
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

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 100)
augroup END

"""""""""""""""""""""""""""""""
" Search
"""""""""""""""""""""""""""""""
set nohls
set ignorecase
set smartcase
nnoremap <leader>pp :GFiles<CR>
nnoremap <leader>pw :Rg <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>pa :Files<space>
nnoremap <leader>pf :Rg<space>

"""""""""""""""""""""""""""""""
" Git
"""""""""""""""""""""""""""""""
set diffopt=vertical
nmap [h <Plug>(GitGutterPrevHunk)
nmap ]h <Plug>(GitGutterNextHunk)
                
"""""""""""""""""""""""""""""""
" LSP
" https://github.com/neoclide/coc.nvim
"""""""""""""""""""""""""""""""
""""" Trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

""""" Trigger completion
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<Tab>" :
            \ coc#refresh()

""""" Confirm completion
if exists('*complete_info')
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

""""" Diagnostics
nnoremap <silent><nowait> <leader>a :<C-u>CocList diagnostics<cr>
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

""""" Code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

""""" Documentation
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

""""" Highlight references
autocmd CursorHold * silent call CocActionAsync('highlight')

""""" Refactoring
nmap <leader>rn <Plug>(coc-rename)

""""" Formatting
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>qf  <Plug>(coc-fix-current)
command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

augroup format_selection
    autocmd!
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

""""" Code actions
""""" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>ac  <Plug>(coc-codeaction)

"""""""""""""""""""""""""""""""
" Statusline
"""""""""""""""""""""""""""""""
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#ignore_bufadd_pat = 'defx|gundo|nerd_tree|startify|tagbar|undotree|vimfiler'

"""""""""""""""""""""""""""""""
" File explorer
"""""""""""""""""""""""""""""""
let g:nnn#set_default_mappings = 0
let g:nnn#statusline = 0
let g:nnn#layout={ 'left': '~30%' }
let g:nnn#replace_netrw=1
let $EDITOR='vi'
let $VISUAL='nvim'
let $NNN_TRASH=1
let $NNN_PLUG='t:treeview'
nnoremap <silent>q :NnnPicker '%:p:h'<CR>

"""""""""""""""""""""""""""""""
" Utils
"""""""""""""""""""""""""""""""
function! SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
