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
" Plug 'tpope/vim-fugitive'
" Plug 'lyuts/vim-rtags'
Plug 'ycm-core/YouCompleteMe'
Plug 'mbbill/undotree'

call plug#end()


colorscheme darktheme
" let g:lightline = { 'colorscheme': 'bluewery' }
" set noshowmode


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

" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END
