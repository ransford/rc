" Vim syntax file
" Language:	objdump -D output
" Maintainer:	syndrowm <syndrowm@gmail.com>
" Last Change:	2007 Jun 05
" This is really just a modified version of syntax/asm.vim
" Have fun reversing.

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore
syn match asmLabel            "[a-z_][a-z0-9_]*:"he=e-1
syn match asmIdentifier               "[a-z_][a-z0-9_]*"


" Various #'s as defined by GAS ref manual sec 3.6.2.1
" Technically, the first decNumber def is actually octal,
" since the value of 0-7 octal is the same as 0-7 decimal,
" I prefer to map it as decimal:
syn match decNumber		"0\+[1-7]\=[\t\n$,; ]"
syn match decNumber		"[1-9]\d*"
syn match octNumber		"0[0-7][0-7]\+"
syn match hexNumber		"0[xX][0-9a-fA-F]\+"
syn match binNumber		"0[bB][0-1]*"
syn match addressNum		"[0]\+804[0-9a-fA-F]\+"
syn match addressNum		"804[0-9afA-F]\+"
syn match addressNum		"0x804[0-9afA-F]\+"
syn match machine		"[0-9a-fA-F][0-9a-fA-F] \+"
syn match jumps			"j[a-z]\+"
syn match calls			"call"
syn match alerts		"\*\*\+[a-zA-Z0-9]\+"

syn match asmSpecialComment	";\*\*\*.*"
syn match asmComment		";.*"hs=s+1
syn match asmComment		"#.*"hs=s+1

syn match asmInclude		"\.include"
syn match asmCond		"\.if"
syn match asmCond		"\.else"
syn match asmCond		"\.endif"
syn match asmMacro		"\.macro"
syn match asmMacro		"\.endm"

syn match asmDirective		"\.[a-z][a-z]\+"


syn case match

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_asm_syntax_inits")
  if version < 508
    let did_asm_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " The default methods for highlighting.  Can be overridden later
  HiLink asmSection	Special
  HiLink asmLabel	Label
  HiLink asmComment	Comment
  HiLink asmDirective	Statement

  HiLink asmInclude	Include
  HiLink asmCond	PreCondit
  HiLink asmMacro	Macro

  HiLink hexNumber	Type
  HiLink decNumber	Number
  HiLink octNumber	Number
  HiLink binNumber	Number
  HiLink machine 	Number	

  HiLink asmSpecialComment Comment
  HiLink asmIdentifier Identifier
  HiLink asmType	Type

  HiLink jumps		Comment
  HiLink calls		PreProc
  HiLink addressNum	WarningMsg
  HiLink alerts		VisualNOS
  "hi addressNum	ctermfg=brown	


  " My default color overrides:
  " hi asmSpecialComment ctermfg=red
  " hi asmIdentifier ctermfg=lightcyan
  " hi asmType ctermbg=black ctermfg=brown

  delcommand HiLink
endif

let b:current_syntax = "asm"

" vim: ts=8
