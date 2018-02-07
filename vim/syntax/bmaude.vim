" Vim syntax file
" Language: B Maude
" Maintainer: Christiano Braga
" Latest Revision: Feb 2018

if exists("b:current_syntax")
  finish
endif

syn match bmaudeIdentifiers '\<\h\w*' 
syn keyword bmaudeMachine MACHINE END   
syn keyword bmaudeClauses VARIABLES CONSTANTS VALUES OPERATIONS
syn keyword bmaudeCommands add=bmaudeConditional,bmaudeRepeat,bmaudeBlock,bmaudeComp
syn keyword bmaudeConditional IF THEN ELSE  
syn keyword bmaudeLoop WHILE DO           
syn keyword bmaudeBlock BEGIN END
syn keyword bmaudeComp OR ;
syn match  bmaudeOperators display "[-+\*/=,\~\<\>\[\]\->]"
syn keyword bmaudeSystemCmd exec execn sexec mc search where and view eof
syn keyword bmaudeBoolean true false
syn region bmaudeSayCmd start='say' end='.)$' 
syn match bmaudeNumber '\d\+'  
syn match bmaudeNumber '[-+]\d\+'
syn match bmaudeComment "---.*$" 
syn match bmaudeComment "\*\*\*.*$"

let b:current_syntax = "bmaude"

hi def link bmaudeIdentifiers Identifiers
hi def link bmaudeBoolean     Boolean
hi def link bmaudeTodo        Todo
hi def link bmaudeComment     Comment
hi def link bmaudeMachine     Statement    
hi def link bmaudeClauses     Statement
hi def link bmaudeLoop        Repeat
hi def link bmaudeConditional Conditional
hi def link bmaudeBlock       Statement
hi def link bmaudeComp        Statement
hi def link bmaudeNumber      Constant
hi def link bmaudeOperators   Operator
hi def link bmaudeSystemCmd   Special
hi def link bmaudeSayCmd      Special 
