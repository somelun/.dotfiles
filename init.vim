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

" run local .nvimrc file from the project directory
set exrc
set secure

set wrap
set linebreak
set ignorecase
set smartcase

" yanks/deletes to goes the system clipboard
set clipboard=unnamedplus

set mouse=a                 " enable mouse support
set mousemodel=popup        " right mouse button pop ups a menu
set mousehide               " hide mouse when typing text

augroup vimrc_autocmds
    autocmd!
    " when there are errors after :make open quickfix
    autocmd QuickFixCmdPost [^l]* cwindow
    " enable relative line numbers in normal and visual modes
    autocmd InsertLeave,WinEnter * set relativenumber
    " enable absolute line numbers in insert mode
    autocmd InsertEnter,WinLeave * set norelativenumber
augroup END

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
set listchars=tab:>-,trail:·

" redefine leader key
let mapleader=" "

" vim-plug settings
call plug#begin('~/.config/nvim/plugged')
Plug 'jremmen/vim-ripgrep'
if has("nvim")
    Plug 'numToStr/Comment.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-lua/plenary.nvim'  " telescope requirement
    Plug 'nvim-telescope/telescope.nvim'
endif
Plug 'ziglang/zig.vim'
Plug 'ericcurtin/CurtineIncSw.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'morhetz/gruvbox'
call plug#end()
lua << EOF
require('Comment').setup()
EOF

if has("nvim")
lua << EOF
    local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        -- Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings
        local opts = { noremap = true, silent = true }
        buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    end

    -- Use new API if available (Neovim ≥ 0.11)
    if vim.lsp and vim.lsp.enable then
        vim.lsp.config.clangd = {
            cmd = { "clangd" },
            autostart = false,
            filetypes = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
            on_attach = on_attach,
            init_options = { fallbackFlags = { "-std=c++17" } },
        }

        vim.lsp.config.zls = {
            cmd = { "zls" },
            autostart = false,
            filetypes = { "zig" },
            on_attach = on_attach,
        }

    else
        -- Backward compatibility (Neovim < 0.11)
        require('lspconfig').clangd.setup {
            on_attach = on_attach,
            autostart = false,
            filetypes = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
            init_options = { fallbackFlags = { "-std=c++17" } }
        }

        require('lspconfig').zls.setup {
            on_attach = on_attach,
            autostart = false,
            filetypes = { "zig" },
        }
    end
EOF
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
let g:netrw_list_hide .=',\(^\|\s\s\)\zs\.\S\+'

" tabs things
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>t<leader> :tabnext
nnoremap <leader>tc :tabclose<CR>

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
nnoremap <silent> <C-E> :call ToggleNetrw()<CR>

" comment.nvim: default gcc / gc mappings are set up automatically by
" require('Comment').setup() above (see plug#end block).
" NOTE: these two stay as nmap/vmap (recursive) on purpose — <Plug>
" mappings require a recursive map to trigger correctly.
" Extra hotkeys for Ctrl+/ and Cmd+/ to match other editors:
nmap <C-/> <Plug>(comment_toggle_linewise_current)
vmap <C-/> <Plug>(comment_toggle_linewise_visual)
if has("nvim-0.9")
    nmap <D-/> <Plug>(comment_toggle_linewise_current)
    vmap <D-/> <Plug>(comment_toggle_linewise_visual)
endif

" Find files using Telescope command-line sugar.
nnoremap <leader>ff :lua require('telescope.builtin').find_files({find_command = { 'find', '.', '-type', 'f', '!', '-path', './build/*' }})<CR>
nnoremap <leader>fg <Cmd>Telescope live_grep<CR>
nnoremap <leader>fb <Cmd>Telescope buffers<CR>
nnoremap <leader>fw <Cmd>Telescope grep_string<CR>

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

" close buffer but keep the window
nnoremap <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

nnoremap <leader>ps :Rg<space>

nnoremap <F5> :call CurtineIncSw()<CR>

" make sure F1 does nothing
nnoremap <F1> <Nop>
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

" quick switch for the color scheme
nnoremap <leader>bg :let &background = (&background ==# 'dark' ? 'light' : 'dark')<CR>
