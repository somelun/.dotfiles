highlight clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "mood2214"

let s:dark = {
      \ 'bg':      '#282828', 'bg1':   '#3c3836', 'bg2':    '#504945',
      \ 'fg':      '#ebdbb2', 'fg2':   '#d5c4a1', 'gray':   '#928374',
      \ 'red':     '#fb4934', 'green': '#b8bb26', 'yellow': '#fabd2f',
      \ 'blue':    '#83a598', 'purple':'#d3869b', 'orange': '#fe8019',
      \ 'linenr':  '#7c6f64',
      \ }

let s:light = {
      \ 'bg':      '#fbf1c7', 'bg1':   '#ebdbb2', 'bg2':    '#d5c4a1',
      \ 'fg':      '#3c3836', 'fg2':   '#504945', 'gray':   '#7c6f64',
      \ 'red':     '#9d0006', 'green': '#79740e', 'yellow': '#b57614',
      \ 'blue':    '#076678', 'purple':'#8f3f71', 'orange': '#af3a03',
      \ 'linenr':  '#a89984',
      \ }

function! s:apply()
  let c = (&background ==# 'light') ? s:light : s:dark

  execute 'highlight Normal       guifg='.c.fg.' guibg='.c.bg
  execute 'highlight MsgArea      guifg='.c.fg.' guibg='.c.bg1
  execute 'highlight StatusLine   guifg='.c.fg.' guibg='.c.bg2
  execute 'highlight StatusLineNC guifg='.c.gray.' guibg='.c.bg1
  execute 'highlight LineNr       guifg='.c.linenr.' guibg='.c.bg
  execute 'highlight CursorLineNr guifg='.c.yellow.' guibg='.c.bg
  execute 'highlight CursorLine   guibg='.c.bg1

  execute 'highlight Comment      guifg='.c.gray.' cterm=italic gui=italic'
  execute 'highlight String       guifg='.c.green
  execute 'highlight Keyword      guifg='.c.red
  execute 'highlight Statement    guifg='.c.red
  execute 'highlight Type         guifg='.c.yellow
  execute 'highlight CustomTypes  guifg='.c.yellow

  execute 'highlight Constant     guifg='.c.purple
  execute 'highlight Identifier   guifg='.c.fg2
  execute 'highlight Function     guifg='.c.blue

  execute 'highlight Cursor       guibg='.c.red
  execute 'highlight iCursor      guibg='.c.red
  execute 'highlight Visual       guifg='.c.bg.' guibg='.c.red

  execute 'highlight PreProc      guifg='.c.orange
  execute 'highlight Special      guifg='.c.orange
  execute 'highlight Error        guifg='.c.bg.' guibg='.c.red
endfunction

set guicursor=n-v-c:block-Cursor
set guicursor+=i:ver25-iCursor

call s:apply()

augroup CustomHighlights
  autocmd!
  autocmd BufEnter * syntax match CustomTypes /\<\(u8\|i8\|u16\|i16\|u32\|i32\)\>/
  autocmd OptionSet background call s:apply()
augroup END
