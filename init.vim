call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sleuth'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'jonsmithers/vim-html-template-literals'
Plug 'alvan/vim-closetag'
Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-sneak'
Plug 'kristijanhusak/vim-dirvish-git'
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'Valloric/MatchTagAlways'
call plug#end()

""""" Global
set mouse=a
let mapleader = ' '
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
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
nnoremap <silent> <leader>l :noh<cr>


""""" Git gutter
let g:gitgutter_map_keys = 0
nmap <silent> ]g <plug>(GitGutterNextHunk)
nmap <silent> [g <plug>(GitGutterPrevHunk)
nmap <silent><leader>gp <plug>(GitGutterPreviewHunk)
nmap <silent><leader>gs <plug>(GitGutterStageHunk)
nmap <silent><leader>gu <plug>(GitGutterUndoHunk)

""""" Theme/syntax highlighting
colorscheme gruvbox
if exists('+termguicolors')
        let &t_8f = "\<esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = 0
colorscheme gruvbox
set background=dark
let g:htl_all_templates = 1

"""""" Closetag
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.ts,*.tsx,*.js,*.jsx'

"""""" MatchTagAlways
nnoremap <leader>% :MtaJumpToOtherTag<cr>
let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'jinja' : 1,
    \ 'typescript': 1,
    \}

""""" Sneak
let g:sneak#label = 1

""""" CoC
set nobackup
set nowritebackup
set shortmess+=c
set updatetime=100
let g:coc_global_extensions = [
    \ 'coc-tsserver',
    \ 'coc-tslint-plugin',
    \ 'coc-angular',
    \ 'coc-prettier',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-yank' ]
nmap <silent> ]d <plug>(coc-diagnostic-prev)
nmap <silent> [d <plug>(coc-diagnostic-next)
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
autocmd CursorHold * silent call CocActionAsync('highlight')
nmap <leader>qf  <plug>(coc-fix-current)
command! -nargs=0 Prettier :CocCommand prettier.formatFile
xmap <leader>= <plug>(coc-format-selected)
nmap <leader>= <plug>(coc-format-selected)
nmap <leader>rn <plug>(coc-rename)

"""""" FZF
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4"
let $FZF_DEFAULT_COMMAND = 'rg --files --ignore-case --hidden -g "!{.git,node_modules,vendor}/*"'
command! -bang -nargs=* GGrep
    \ call fzf#vim#grep(
    \   'git grep --line-numb}er -- '.shellescape(<q-args>), 0,
    \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
command! -bang -nargs=? -complete=dir Files
     \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
set termguicolors
nmap <leader>p :GFiles<cr>
nmap <leader>P :Files ~<cr>
nmap <leader>b :Buffers<cr>
nmap <leader>h :History<cr>
nmap <leader>f :Lines<cr>
nmap <leader>F :GGrep<cr>
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }

""""" Dirvish
autocmd BufEnter * silent! lcd %:p:h
let g:loaded_netrwPlugin = 1
nmap <tab> <plug>(dirvish-toggle)
nnoremap <silent> <plug>(dirvish-toggle) :<c-u>call <sid>dirvish_toggle()<cr>
function! s:dirvish_toggle() abort
  let l:last_buffer = bufnr('$')
  let l:i = 1
  let l:dirvish_already_open = 0
  while l:i <= l:last_buffer
    if bufexists(l:i) && bufloaded(l:i) && getbufvar(l:i, '&filetype') ==? 'dirvish'
      let l:dirvish_already_open = 1
      execute ':'.l:i.'bd!'
    endif
    let l:i += 1
  endwhile
  if !l:dirvish_already_open
    35vsp +Dirvish
  endif
endfunction
function! s:dirvish_open() abort
  let l:line = getline('.')
  if l:line =~? '/$'
    call dirvish#open('edit', 0)
  else
    call <sid>dirvish_toggle()
    execute 'e '.l:line
  endif
endfunction
augroup dirvish_commands
  autocmd!
  autocmd FileType dirvish nnoremap <silent> <buffer> <c-r> :<c-u>Dirvish %<cr>
  autocmd FileType dirvish unmap <silent> <buffer> <cr>
  autocmd FileType dirvish nnoremap <silent> <buffer> <cr> :<c-u> call <sid>dirvish_open()<cr>
  autocmd FileType dirvish setlocal nonumber norelativenumber statusline=%F
  autocmd FileType dirvish nnoremap <silent> <buffer> t :!tree %<cr>
  autocmd FileType dirvish nnoremap <silent> <buffer> <esc> :call <sid>dirvish_toggle()<cr>
  autocmd FileType dirvish nnoremap <silent> <buffer> <c-c> :call <sid>dirvish_toggle()<cr>
  autocmd FileType dirvish nnoremap <silent> <buffer> <c-[> :call <sid>dirvish_toggle()<cr>
augroup END

""""" Startify
nnoremap <silent>~ :Startify <cr>
autocmd FileType startify nnoremap <silent> <esc> :normal q<cr>
let g:startify_list_order = ['files', 'bookmarks']
let g:startify_bookmarks =  [{'c': '~/dotfiles/init.vim'},
                            \{'ru': '~/src/raasdev/raas-ui'},
                            \{'rr': '~/src/raasdev/raas'},
                            \{'rd':'~/src/raasdev/raas-docker'},
                            \{'s': '~/src/raasdev/salt'},
                            \{'w': '~/src/raasdev'},
                            \{'d': '~/dotfiles'}]

""""" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#ignore_bufadd_pat = '!'

""""" Format options (autocomment)
set formatoptions-=ro

