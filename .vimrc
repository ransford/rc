" ~/.vimrc
" Ben Ransford http://ben.ransford.org/

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" set softtabstop=4     " 4-space tabs
set ai                  " always set autoindenting on
set backupdir=~/.tmp    " where to keep backups
set bs=2                " allow backspacing over everything in insert mode
set clipboard=unnamed   " use system clipboard
set dir=~/.tmp          " where to keep swap files
set display=uhex        " display unprintable characters as <xx> (hex)
set formatoptions=tcq2  " see help -- basically, auto-wrap nicely @ textwidth
set history=50          " keep 50 lines of command line history
set laststatus=2        " status line always (=1 to restrict to >1-win case)
set list                " show tabs and trailing spaces
exec "set listchars=tab:\ubb\u6f0,trail:\u2591"
set modelines=2         " check first and last 2 lines of file for modeline
set nobackup            " keep a backup file
set hlsearch            " highlight search results
set mouse=n             " scroll with the mouse in normal (not insert) mode
set nofoldenable        " h8 folding
set nostartofline       " keep the cursor in its column as much as possible
set number              " use line numbering
set scrolloff=3         " keep the cursor N lines away from top/bottom edges
set showcmd             " show commands as they're being typed
set showmatch           " at ),],}, briefly jump the cursor to opening bracket
set showmode            " show a message when in insert/replace/visual mode
set nosmartindent       " smart indentation (sucks)
set smarttab            " smart tab interpretation
set spellfile=~/.vim/spell/en.utf-8.add " my own words
set spelllang=en_us     " we're #1
set statusline=%m\ %#StatusLineNC#%F%#StatusLine#\ %y%(\ [#%n%R]%)
set statusline+=%=%#StatusLineNC#\ L%l/%L,c%c\ %#StatusLine#\  " pretty status line
set viminfo='20,\"50    " read/write .viminfo, <=50 lines of registers
set viminfo+=h          " at startup, don't highlight old search
set wildmenu wildmode=longest,list,full  " bash-like autocompletion behavior

helptags ~/.rc/.vim/doc

let g:pathogen_disabled = []
if v:version < 742
  call add(g:pathogen_disabled, 'vim-go')
endif

call pathogen#infect()
call pathogen#helptags()
filetype plugin on      " enable ftplugins

autocmd BufNewFile,BufRead *.R       setlocal ft=r
autocmd BufNewFile,BufRead mutt-*    setlocal ft=mail
autocmd BufNewFile,BufRead *.ll      setlocal ft=llvm
autocmd BufNewFile,BufRead *.td      setlocal ft=tablegen
autocmd BufNewFile,BufRead svn-commit*.tmp setlocal ts=4 sw=4 tw=72 ai et
                                                  \ spell
" autocmd BufWritePost,FileWritePost *.go execute 'Lint' | cwindow

autocmd FileType gitcommit setlocal tw=80 ai et spell | syntax on
autocmd FileType gitcommit DiffGitCached | setlocal ro
autocmd FileType gitcommit wincmd x " jump to commit msg window

autocmd FileType go setlocal ts=4 sw=4 tw=80 cindent ai si noet nolist
                            \ | let g:go_highlight_build_constraints = 1
                            \ | let g:go_highlight_extra_types = 1
                            \ | let g:go_highlight_fields = 1
                            \ | let g:go_highlight_functions = 1
                            \ | let g:go_highlight_methods = 1
                            \ | let g:go_highlight_operators = 1
                            \ | let g:go_highlight_structs = 1
                            \ | let g:go_highlight_types = 1
                            \ | let g:go_auto_sameids = 1
                            \ | let g:go_auto_type_info = 1
                            \ | let g:go_fmt_autosave = 1
                            \ | let g:go_fmt_commands = "goimports"
                            \ | let g:go_auto_type_info = 1
autocmd FileType go inoremap <buffer> . .<C-x><C-o>

autocmd FileType perl  setlocal ts=4 sw=4 tw=80 ai et cindent si
                                \ cinkeys=0{,0},0),:,!^F,o,O,e
autocmd FileType python setlocal ts=4 sw=4 tw=79 ai et cindent si
                                \ cinkeys=0{,0},0),:,!^F,o,O,e
                                \ | let g:pymode_lint_on_write=0
                                \ | let g:pymode_doc=0
                                \ | let g:pymode_rope=0
                                \ | let g:pymode_rope_lookup_project=0
                                \ | let g:pymode_rope_complete_on_dot=0
autocmd FileType {c,cpp,java,cs} setlocal ts=4 sw=4 tw=80 ai et cindent si
                                       \ tags=./tags,tags;
autocmd FileType scala setlocal ts=2 sw=2 tw=100 ai et cindent si
                                       \ tags=./tags,tags;
autocmd FileType javascript setlocal ts=2 sw=2 tw=100 ai et cindent si
autocmd FileType {llvm,tablegen} setlocal ts=2 sw=2 tw=80 ai et nosi
autocmd FileType mail setlocal ai et nosi tw=76 spell
autocmd FileType text setlocal ai nosi tw=80 spell
autocmd FileType *tex setlocal ai et nosi tw=80 spell
autocmd FileType *tex let _=matchadd('ErrorMsg', '[^\x00-\x7f]', -1)
autocmd FileType {html,xml} setlocal ai et nosi tw=80 spell
                               \ | runtime macros/matchit.vim
autocmd FileType make setlocal noet

if has("gui_running")
  set cursorline        " subtly highlight the current line
  set guioptions-=T     " don't need to see toolbar buttons
  set lines=40 columns=90

  if (has("win32"))
    set guifont=Ubuntu_Mono:h14:cANSI

    " make shift-insert paste (well, as long as MiddleMouse pastes)
    map! <S-Insert> <MiddleMouse>
  elseif has("mac")
    set guifont=Hack\ Regular:h14
  else
    set guifont=Hack\ 13
  endif
endif

" switch syntax highlighting on when the terminal has colors
if &t_Co > 2 || has("gui_running")
  syntax on

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
    autocmd VimEnter * autocmd WinEnter * let w:created=1
    autocmd VimEnter * let w:created=1
    autocmd VimEnter * if &tw > 0
        \ | let w:m1=matchadd('ErrorMsg', printf('\%%>%dv.\+', &tw), -1)
        \ | endif

    " http://vim.wikia.com/wiki/Highlight_long_lines
    autocmd WinEnter * if !exists('w:created') && &tw > 0
        \ | let w:m1=matchadd('ErrorMsg', printf('\%%>%dv.\+', &tw), -1)
        \ | endif
    autocmd BufWinLeave * call clearmatches()
  endif

endif

if has("gui_macvim")
  set transparency=4
endif

" nice keyboard mappings
map Q gq

let mapleader=","
map <Leader>d :set fileformat=dos<CR>
map <Leader>p a<C-R>=system("pwgen -s -c -n -y 16 1 \| tr -d '\\n'")<CR><Esc>
map <Leader>u :set fileformat=unix<CR>
map <Leader>f :execute "Ag! " . expand("<cword>")<CR>
map <Leader>c :let &colorcolumn=col(".")<CR>
map <Leader>t "=strftime("%c %Z")<CR>p
autocmd FileType python map <Leader>y :PymodeLint<CR>
autocmd FileType json map <Leader>j :!jq .<CR>

" globally replace word under cursor with <Leader>r<Leader>R
nnoremap <Leader>r ciw
" replace the most recently inserted ("rename")
nnoremap <Leader>R :%s/<c-r>-/<c-r>./gc<CR>

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
