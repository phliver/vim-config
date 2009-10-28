" Nathan L Smith's .vimrc
" http://github.com/smith/vim-config/

syntax on
filetype on
filetype indent on
filetype plugin on

" General options
set autoread
set hidden
set incsearch
set ignorecase
set smartcase
set wildmenu
set wildmode=list:longest
set backspace=indent,eol,start
set backupdir=/tmp
set history=1000
set shortmess=at

" Reload vimrc after editing it
au BufWrite *vimrc source %

" Tabs
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

" Key Mapping
" TODO: Nothing to see here

" GUI options
if has("gui_running")
  " No menus and no toolbar
  set guioptions-=m
  set guioptions-=T

  " Left handed scrollbar
  set guioptions-=r
  set guioptions+=l

  set co=80
  set lines=45
endif

" Appearance
set ruler
set title
set wrap
set bg=dark
set scrolloff=3

highlight Normal guifg=#888888 guibg=Black
highlight Cursor guifg=Black guibg=Yellow
highlight Keyword guifg=#FF6600
highlight Define guifg=#FF6600
highlight Comment guifg=#9933CC
highlight Type guifg=White gui=NONE
highlight rubySymbol guifg=#339999 gui=NONE
highlight Identifier guifg=White gui=NONE
highlight rubyStringDelimiter guifg=#66FF00
highlight rubyInterpolation guifg=White
highlight rubyPseudoVariable guifg=#339999
highlight Constant guifg=#FFEE98
highlight Function guifg=#FFCC00 gui=NONE
highlight Include guifg=#FFCC00 gui=NONE
highlight Statement guifg=#FF6600 gui=NONE
highlight String guifg=#66FF00
highlight Search guibg=White
highlight ExtraWhitespace guibg=Red ctermbg=Red

" Highlight trailing whitespace
au BufWinEnter * match ExtraWhitespace /\s\+$\| \+\ze\t/
au BufWrite * match ExtraWhitespace /\s\+$\| \+\ze\t/

function! Indent4Spaces()
  set tabstop=4
  set softtabstop=4
  set shiftwidth=4
endfunction

" Ruby
function! UseRubyIndent ()
  function! RubyEndToken ()
    let current_line = getline( '.' )
    let braces_at_end = '{\s*\(|\(,\|\s\|\w\)*|\s*\)\?$'
    let stuff_without_do = '^\s*\(class\|if\|unless\|begin\|case\|for\|module\|while\|until\|def\)'
    let with_do = 'do\s*\(|\(,\|\s\|\w\)*|\s*\)\?$'
    if match(current_line, braces_at_end) >= 0
      return "\<CR>}\<C-O>O"
    elseif match(current_line, stuff_without_do) >= 0
      return "\<CR>end\<C-O>O"
    elseif match(current_line, with_do) >= 0
      return "\<CR>end\<C-O>O"
    else
      return "\<CR>"
    endif
  endfunction

  setlocal tabstop=2
  setlocal softtabstop=2
  setlocal shiftwidth=2
  imap <buffer> <CR> <C-R>=RubyEndToken()<CR>
endfunction
au FileType ruby,eruby call UseRubyIndent()

" Use ruby syntax for capfiles
" FIXME: These don't work and I don't know why
au BufNewFile, BufRead Capfile setf ruby
au BufNewFile, BufRead .caprc setf ruby

" JavaScript
function! JavaScriptFold()
  setl foldmethod=syntax
  setl foldlevelstart=99
  syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

  function! FoldText()
    return substitute(getline(v:foldstart), '{.*', '{...}', '')
  endfunction
  setl foldtext=FoldText()
endfunction

au FileType javascript call Indent4Spaces()
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl foldlevel=99

" PHP
let php_folding=1
au FileType php call Indent4Spaces()
au FileType php setl foldlevel=99

" MacVim
if has("gui_macvim")
    set transp=1
    set anti enc=utf-8 gfn=Menlo:h14,Monaco:h14
    " MacVim seems to not source my vimrc
    au BufRead * source ~/.vimrc
endif

" Windows
if has("win32")
    " Use CUA keystrokes for clipboard: CTRL-X, CTRL-C, CTRL-V and CTRL-z
    source $VIMRUNTIME/mswin.vim

    set backupdir=c:\temp,.
    set guifont=Consolas:h13:cANSI,Anonymous\ Pro:h13:cANSI
endif
