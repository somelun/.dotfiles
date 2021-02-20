set nocompatible
syntax on

set hidden
set noerrorbells
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set belloff=all

set nu
set nowrap
set smartcase

set noswapfile
set nobackup
set undodir=~/.config/nvim/undodir
set undofile

set scrolloff=8

set incsearch

set t_Co=256

set background=dark
colorscheme PaperColor

set list
set listchars=tab:>-,trail:·"

" different font size for macvim
if has('gui_macvim')
    set guifont=Menlo\ Regular:h15"
    " set guifont=Monoid\ Retina:h14
    let macvim_skip_colorscheme=1"
    " removes both scrollbars
    set guioptions=
    set laststatus=2
    set lines=47
    set columns=160
endif

" redefine leader key
let mapleader=" "

" vim-plug settings
call plug#begin('~/.config/nvim/plugged')
Plug 'preservim/nerdcommenter'
Plug 'jremmen/vim-ripgrep'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'ziglang/zig.vim''
Plug 'mbbill/undotree'
call plug#end()

:lua << EOF
    local lspconfig = require('lspconfig')

    local on_attach = function(_, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        require('completion').on_attach()
    end

    local servers = {'zls', 'clangd'}
    for _, lsp in ipairs(servers) do 
        lspconfig[lsp].setup {
            on_attach = on_attach,
        }
    end
EOF

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Enable completions as you type
let g:completion_enable_auto_popup = 0


" ripgrep settings
if executable('rg')
    let g:rg_derive_root='true'
endif

" bind command %:h to %%
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 0
let g:netrw_browse_split = 0    " open file in the same tab
let g:netrw_altv = 1
let g:netrw_winsize = 20
let g:netrw_sort_by = "exten"
let g:netrw_list_hide = '.DS_Store'
let g:netrw_list_hide .=',\(^\|\s\s\)\zs\.\S+'

let g:NetrwIsOpen=0
function! ToggleNetrw()
  if g:NetrwIsOpen
    let i = bufnr("$")
      while (i >= 1)
        if (getbufvar(i, "&filetype") == "netrw")
          silent exe "bwipeout " . i 
        endif
        let i-=1
      endwhile
      let g:NetrwIsOpen=0
  else
    let g:NetrwIsOpen=1
    silent Lexplore
  endif
endfunction

function! OpenVSplit()
    :normal v
    let g:path=expand('%:p')
    !q!
    execute 'belowright vnew' g:path
    :normal <C-l>
endfunction

" function! NetrwMappings()
"   noremap <buffer> V :call OpenVSplit()<CR>
   noremap <silent> <C-E> :call ToggleNetrw()<CR>
" endfunction

" autogroup netrw_mappings
"     autocmd!
"     autocmd filetype netrw call NetrwMappings()
" autogroup END

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

" command! Qbuffers call setqflist(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '{"bufnr":v:val}'))

" remap keys

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <silent> <C-P> :Buffers<CR>
nnoremap <silent> <C-p> :Files<CR>

nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>ps :Rg<space>

noremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

nnoremap <silent> <leader>gd :YcmCompleter GoTo<CR>
nnoremap <silent> <leader>gf :YcmCompleter FixIt<CR>

nmap <F1> <nop>
nnoremap <silent> <C-l> :<C-u>noh<CR><C-l>
