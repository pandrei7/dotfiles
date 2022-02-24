" ViM syntax file
" Language: Cool
" Maintainer: Alfonso S. Siciliano alfonso.siciliano@email.com
" License: Public Domain - No Warranty
" Created: 27 November 2015
" Latest Revision: 20 September 2017

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

"Keywords
syn case ignore
syn keyword keywords class inherits new
syn keyword keywords in isvoid let loop pool then while case esac of not else fi if
syn keyword boolConstKeywords true false
syn keyword self self

"Match
syn match escapeChars '\\\"\|\\0\|\\'				contained
syn match escapeChars '\\b\|\\t\|\\f\|\\n\|\\r\|\\t\|\\v'	contained
syn match classID  '\u[0-9a-zA-Z_]*'
syn match objectID '\l[0-9a-zA-Z_]*'
syn match at 	   '@' 						contained
syn match number   '\d\+'
syn match singleLineComment '--.*$'
syn match caseOperator '=>'

"Region
syn region multiLinesComment start='(\*' end='\*)'
syn region string start='\\\@<!"' end='\\\@<!"' 	contains=escapeChars
syn region dispatch start='@' end='\.' 			contains=at,classID

"Error
syn match errors ":\s*\l\S*"
syn match errors "@\s*\l\S*"

let b:current_syntax = "cool"

hi def link string 			String
hi def link keywords 			Statement
hi def link boolConstKeywords		Constant
hi def link number			Number
hi def link escapeChars			SpecialChar
hi def link classID			Type
hi def link self			Special
hi def link at				Special
hi def link caseOperator		Special
hi def link singleLineComment		Comment
hi def link multiLinesComment		Comment
hi def link errors			Error
