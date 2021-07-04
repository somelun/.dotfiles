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
set wrap
set linebreak
set nolist
set ignorecase
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
if has("nvim")
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/completion-nvim'
endif
Plug 'MattesGroeger/vim-bookmarks'
Plug 'ziglang/zig.vim'
Plug 'mbbill/undotree'
call plug#end()

if has("nvim")
:lua << EOF
    local lspconfig = require('lspconfig')

    local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        --Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { noremap=true, silent=true }

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    end

    local servers = { "clangd", "zls" }
    for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
            on_attach = on_attach,
            autostart = false,
        }
    end
EOF

set completeopt=menuone,noinsert,noselect   " set completeopt to have a better completion experience
let g:completion_enable_auto_popup = 0      " disable completions as you type

endif " has("nvim")

" fzf settings
let g:fzf_preview_window = []           " no preview
let g:fzf_layout = { 'down': '~25%' }   " window position and size

" ripgrep settings
if executable('rg')
    let g:rg_derive_root='true'
endif

" vim-bookmarks
" let g:bookmark_no_default_key_mappings = 1

" bind command %:h to %%
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" netrw settings
let g:netrw_banner = 1
let g:netrw_liststyle = 1
let g:netrw_browse_split = 0    " open file in the same tab
let g:netrw_altv = 1
let g:netrw_winsize = 20
let g:netrw_sort_by = "exten"
let g:netrw_list_hide = '.DS_Store'
let g:netrw_list_hide .=',\(^\|\s\s\)\zs\.\S+'


" custom netrw toggle
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

noremap <silent> <C-E> :call ToggleNetrw()<CR>
" ~custom netrw toggle

set mouse=a                         " enable mouse support
set mousemodel=popup                " right mouse button pop ups a menu
set mousehide                       " hide mouse when typing text

" nerd comment settings
let g:NERDSpaceDelims = 1           " Add spaces after comment delimiters by default
let g:NERDDefaultAlign = 'left'     " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDCommentEmptyLines = 1     " Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDToggleCheckAllLines = 1   " Enable NERDCommenterToggle to check all selected lines is commented or not


" keys remap
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <silent> <C-p> :Buffers<CR>
nnoremap <silent> <C-g> :Files<CR>

nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>ps :Rg<space>

noremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

nmap <F1> <nop>
nnoremap <silent> <C-l> :<C-u>noh<CR><C-l>
