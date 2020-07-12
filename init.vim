call plug#begin()
Plug 'itchyny/lightline.vim'
" Plug 'airblade/vim-gitgutter'
call plug#end()

colo iceberg
syntax on
set noshowmode
set number
" set number relativenumber

filetype plugin indent on
set tabstop=4           " show existing tab with 4 spaces width
set softtabstop=4
set shiftwidth=4        " when indenting with '>', use 4 spaces width
set expandtab           " on pressing tab, insert 4 spaces

set listchars+=space:.
set list

" bind command %:h to %%
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" netrw
let g:netrw_liststyle = 1
let g:netrw_browse_split = 3
let g:netrw_winsize = 25

" let g:netrw_banner = 0
" let g:netrw_liststyle = 3
" let g:netrw_browse_split = 4
" let g:netrw_altv = 1
" let g:netrw_winsize = 25
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END

