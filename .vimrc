" ~/.vimrc
" Ben Ransford http://ben.ransford.org/

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" set softtabstop=4     " 4-space tabs
set ai                  " always set autoindenting on
set backupdir=~/.tmp    " where to keep backups
set bs=2                " allow backspacing over everything in insert mode
set dir=~/.tmp          " where to keep swap files
set display=uhex        " display unprintable characters as <xx> (hex)
set formatoptions=tcq2  " see help -- basically, auto-wrap nicely @ textwidth
set history=50          " keep 50 lines of command line history
set laststatus=2        " status line always (=1 to restrict to >1-win case)
set modelines=2         " check first and last 2 lines of file for modeline
set nobackup            " keep a backup file
set hlsearch            " highlight search results
set nofoldenable        " h8 folding
set nostartofline       " keep the cursor in its column as much as possible
set nonumber            " don't use line numbering
set scrolloff=3         " keep the cursor N lines away from top/bottom edges
set showcmd             " show commands as they're being typed
set showmatch           " at ),],}, briefly jump the cursor to opening bracket
set showmode            " show a message when in insert/replace/visual mode
set nosmartindent       " smart indentation (sucks)
set smarttab            " smart tab interpretation
set spelllang=en_us     " we're #1
set statusline=%m\ %F\ %y%(\ [#%n%R]%)%=%l/%L " pretty status line
set viminfo='20,\"50    " read/write .viminfo, <=50 lines of registers
set viminfo+=h          " at startup, don't highlight old search
set wildmenu wildmode=longest,list,full  " bash-like autocompletion behavior

helptags ~/.rc/.vim/doc

call pathogen#infect()
call pathogen#helptags()
filetype plugin on      " enable ftplugins

"""""
" autocmd stuff, like emacs's hooks
"""""
if has("autocmd")
 autocmd BufNewFile,BufRead *.R       setlocal ft=R
 autocmd BufNewFile,BufRead mutt-*    setlocal ft=mail
 autocmd BufNewFile,BufRead *.txt     setlocal ai et nosi tw=80 spell
 autocmd BufNewFile,BufRead *.ll      setlocal ft=llvm
 autocmd BufNewFile,BufRead *.td      setlocal ft=tablegen
 autocmd BufNewFile,BufRead svn-commit*.tmp setlocal ts=4 sw=4 tw=72 ai et
                                                   \ spell
 autocmd FileType gitcommit setlocal tw=80 ai et spell | syntax on
 autocmd FileType gitcommit DiffGitCached | setlocal ro
 autocmd FileType gitcommit wincmd x

 autocmd FileType {python,perl} setlocal ts=4 sw=4 tw=80 ai et cindent si
                                       \ cinkeys=0{,0},0),:,!^F,o,O,e
 autocmd FileType {c,cpp,java} setlocal ts=4 sw=4 tw=80 ai et cindent si
                                      \ makeprg=ant\ -emacs
 autocmd FileType {llvm,tablegen} setlocal ts=2 sw=2 tw=80 ai et nosi
 autocmd FileType mail setlocal ai et nosi tw=76 spell
 autocmd FileType *tex setlocal ai et nosi tw=80 spell
 autocmd FileType {html,xml} setlocal ai et nosi tw=80 spell
                                \ | runtime macros/matchit.vim
endif


"""""
" gui stuff, for gvim or vim -g
"""""
if has("gui_running")
  set cursorline        " subtly highlight the current line
  set guioptions-=T     " don't need to see toolbar buttons

  if (has("win32"))
    set guifont=Ubuntu_Mono:h16:cANSI
    set lines=40 columns=90

    " make shift-insert paste (well, as long as MiddleMouse pastes)
    map! <S-Insert> <MiddleMouse>
  else
    set guifont=Ubuntu_Mono:h16
    set lines=32 columns=86
  endif
endif

" switch syntax highlighting on when the terminal has colors
if &t_Co > 2 || has("gui_running")
  syntax on
  colorscheme solarized " pretty color scheme
  if has("gui_running")
    set background=light
  else
    set background=dark
  endif

  hi default link CursorColumn LineNr
  hi default link CursorLine LineNr
  hi default link SpellBad WarningMsg

  " trailing whitespace
  " http://vim.wikia.com/wiki/Highlight_unwanted_spaces
  hi default link ExtraWhitespace ErrorMsg
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/

  if v:version >= 702
    " lines over 80 chars
    " http://vim.wikia.com/wiki/Detect_window_creation_with_WinEnter
    autocmd VimEnter * let w:m1=matchadd('Error', '\%>80v.\+', -1)
    autocmd VimEnter * autocmd WinEnter * let w:created=1
    autocmd VimEnter * let w:created=1

    " http://vim.wikia.com/wiki/Highlight_long_lines
    autocmd WinEnter * if !exists('w:created')
                       \ | let w:m1=matchadd('Error', '\%>80v.\+', -1)
                       \ | endif
    autocmd BufWinLeave * call clearmatches()
  endif

endif

if has("gui_macvim")
  set transparency=4
endif

" nice keyboard mappings
map Q gq
map :ud :set fileformat=dos<CR>
map :uu :set fileformat=unix<CR>
map <F7> :make<CR>
imap <ESC>s <C-R>="[" . $USER . strftime(" %c") . "]"<CR>

" alias :W to :w for slow shift fingers
cnoreabbrev W w

" skip paren matching -- it's too slow
if version >= 700
  ":NoMatchParen and :DoMatchParen toggle this
  let loaded_matchparen = 1
endif

" load local mods
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

" vim: expandtab
