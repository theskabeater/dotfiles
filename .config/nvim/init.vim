"vis
syntax on

set relativenumber
set hidden
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nowrap
set noswapfile
set nobackup
set updatetime=100
set shortmess+=c
set colorcolumn=110
set signcolumn=yes
set noshowmode
set nohls
set diffopt=vertical

"cursor
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
    \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor

"plugins
call plug#begin('~/.vim/plugged')

"lsp
Plug 'neovim/nvim-lsp'
Plug 'haorenW1025/completion-nvim'
Plug 'haorenW1025/diagnostic-nvim'

"git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

"syntax
Plug 'cakebaker/scss-syntax.vim'
Plug 'jonsmithers/vim-html-template-literals'
Plug 'leafgarland/typescript-vim'

"theme
Plug 'fatih/molokai'

"status bar
Plug 'itchyny/lightline.vim'

"landing page
Plug 'mhinz/vim-startify'

"indent guides
Plug 'nathanaelkane/vim-indent-guides'

"search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

"set leader
let mapleader = " "

" lsp
lua << EOF
  local nvim_lsp = require('nvim_lsp')

  local on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    require'diagnostic'.on_attach()
    require'completion'.on_attach()

    -- Mappings.
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
  end

  local servers = {'tsserver'}
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
    }
  end
EOF

let g:completion_enable_snippet = 'UltiSnips'
let g:completion_enable_fuzzy_match = 1
let g:completion_enable_autopopup = 0

" enable syntax highlighting for template literals
let g:htl_all_templates = 1

"highlight yank
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 100)
augroup END

"reload lsp
nnoremap <leader><S-r> :lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>

"use tab for autocompletion
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ completion#trigger_completion()


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

"search binds
nnoremap <C-p> :GFiles<CR>
nnoremap <leader>f :Rg<space>

"netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1

"theme
au ColorScheme molokai hi Normal ctermbg=None
let g:rehash256 = 1
colorscheme molokai

"trim trailing white space
autocmd BufWritePre * %s/\s\+$//e

"util for checking syntax
function! SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
