syntax on

set noerrorbells
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.config/nvim/undodir
set incsearch

set listchars+=space:.
set list

let mapleader=" "

call plug#begin('~/.config/nvim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'BurntSushi/ripgrep'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'ycm-core/YouCompleteMe'
Plug 'mbbill/undotree'

call plug#end()

if executable('rg')
    let g:rg_derive_root='true'
endif


colorscheme darktheme
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }
set noshowmode


" bind command %:h to %%
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 1
let g:netrw_browse_split = 0    " open file in the same tab
let g:netrw_winsize = 25
let g:netrw_sort_by = "exten"
let g:netrw_list_hide= '.DS_Store'

let g:netrw_altv = 1

" let clangd fully control code completion
let g:ycm_clangd_uses_ycmd_caching = 0
" use installed clangd, not YCM-bundled clangd which doesn't get updates.
let g:ycm_clangd_binary_path = exepath("clangd")

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>

nnoremap <leader>u :UndotreeShow<CR>

nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

nnoremap <silent> <leader>gd :YcmCompleter GoTo<CR>
nnoremap <silent> <leader>gf :YcmCompleter FixIt<CR>