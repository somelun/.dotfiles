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
colorscheme gruvbox

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
Plug 'ekalinin/Dockerfile.vim'
Plug 'ericcurtin/CurtineIncSw.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'morhetz/gruvbox'
call plug#end()

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX) && getenv('TERM_PROGRAM') != 'Apple_Terminal')
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

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
" let g:fzf_preview_window = []           " no preview
let g:fzf_preview_window = ['right,50%', 'ctrl-/']
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

map <leader>tn :tabnew<cr>
map <leader>t<leader> :tabnext
map <leader>tc :tabclose<cr>

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
let g:NERDCustomDelimiters = {'c': { 'left': '//', 'right': '', 'leftAlt': '//' }}

" keys remap
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>

" fzf remaps
nnoremap <silent> <C-p> :Buffers<CR>
nnoremap <silent> <C-g> :Files<CR>

" close buffer but keep the window
map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>ps :Rg<space>

noremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

map <F5> :call CurtineIncSw()<CR>

nmap <F1> <nop>
nnoremap <silent> <C-l> :<C-u>noh<CR><C-l>

" clang format with Ctrl+K
map <C-K> :pyf /usr/local/opt/llvm/share/clang/clang-format.py<cr>
