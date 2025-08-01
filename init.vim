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

set mouse=a                 " enable mouse support
set mousemodel=popup        " right mouse button pop ups a menu
set mousehide               " hide mouse when typing text

" enable relative line numbers in normal and visual modes
autocmd InsertLeave,WinEnter * set relativenumber
" enable absolute line numbers in insert mode
autocmd InsertEnter,WinLeave * set norelativenumber
" ensure line numbers are always on
set number

set noswapfile
set nobackup
set undodir=~/.config/nvim/undodir
set undofile

set scrolloff=8

set incsearch

" set t_Co=256

set termguicolors

" color scheme
set background=dark
colorscheme mood2214
" colorscheme gruvbox

" what trailing symbols we need to see
set list
set listchars=tab:>-,trail:·"

" redefine leader key
let mapleader=" "

" vim-plug settings
call plug#begin('~/.config/nvim/plugged')
Plug 'preservim/nerdcommenter'
Plug 'jremmen/vim-ripgrep'
if has("nvim")
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/completion-nvim'
    Plug 'nvim-lua/plenary.nvim'  " telescope requirement
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.6' }
endif
Plug 'ziglang/zig.vim'
Plug 'ericcurtin/CurtineIncSw.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'morhetz/gruvbox'
call plug#end()

if has("nvim")
:lua << EOF
    local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        --Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { noremap = true, silent = true }

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    end

    require('lspconfig').clangd.setup {
        on_attach = on_attach,
        autostart = false,
        filetypes = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
        init_option = { fallbackFlags = { "-std=c++17" } }
    }

    require('lspconfig').zls.setup {
        on_attach = on_attach,
        autostart = false,
        filetypes = { "zig" },
}
EOF

set completeopt=menuone,noinsert,noselect   " set completeopt to have a better completion experience
let g:completion_enable_auto_popup = 0      " disable completions as you type
endif " has("nvim")

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

" tabs things
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

" custom netrw toggle
noremap <silent> <C-E> :call ToggleNetrw()<CR>

" nerd comment settings
let g:NERDSpaceDelims = 1           " Add spaces after comment delimiters by default
let g:NERDDefaultAlign = 'left'     " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDCommentEmptyLines = 1     " Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDToggleCheckAllLines = 1   " Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDCustomDelimiters = {'c': { 'left': '//', 'right': '', 'leftAlt': '//' }}
" custom hotkey for the toggle comment
map <C-/> <Plug>NERDCommenterToggle

" Find files using Telescope command-line sugar.
nnoremap <leader>ff :lua require('telescope.builtin').find_files({find_command = { 'find', '.', '-type', 'f', '!', '-path', './build/*' }})<CR>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fw <cmd>Telescope grep_string<cr>

" telescope default is normal mode
:lua << EOF
require('telescope').setup{
    defaults = {
        initial_mode = "normal",
    }
}
EOF

" keys remap
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>

" mapping shift U to undo undo
nnoremap U <C-R>

" close buffer but keep the window "
map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

nnoremap <leader>ps :Rg<space>

map <F5> :call CurtineIncSw()<CR>

" make sure F1 does nothing
nmap <F1> <nop>
" clears selections
nnoremap <silent> <C-l> :<C-u>noh<CR><C-l>

" indent settings
set foldmethod=syntax
set foldlevelstart=99

" disable arrow keys so I don't use them
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
