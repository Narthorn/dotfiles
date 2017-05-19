set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "thorn"

" General colors
hi Normal           ctermfg=NONE        ctermbg=NONE        cterm=NONE
hi NonText          ctermfg=black       ctermbg=NONE        cterm=NONE

hi Cursor           ctermfg=black       ctermbg=white       cterm=reverse
hi LineNr           ctermfg=darkgray    ctermbg=NONE        cterm=NONE

hi VertSplit        ctermfg=darkgray    ctermbg=NONE        cterm=NONE
hi StatusLine       ctermfg=white       ctermbg=NONE        cterm=NONE
hi StatusLineNC     ctermfg=blue        ctermbg=NONE        cterm=NONE  

hi Folded           ctermfg=NONE        ctermbg=NONE        cterm=NONE
hi Title            ctermfg=NONE        ctermbg=NONE        cterm=NONE
hi Visual           ctermfg=NONE        ctermbg=NONE        cterm=REVERSE

hi SpecialKey       ctermfg=NONE        ctermbg=NONE        cterm=NONE

hi WildMenu         ctermfg=white       ctermbg=red         cterm=NONE
hi PmenuSbar        ctermfg=black       ctermbg=white       cterm=NONE
"hi Ignore           ctermfg=NONE        ctermbg=NONE        cterm=NONE

hi Error            ctermfg=white       ctermbg=red         cterm=NONE
hi ErrorMsg         ctermfg=white       ctermbg=red         cterm=NONE
hi WarningMsg       ctermfg=white       ctermbg=red         cterm=NONE
hi LongLineWarning  ctermfg=NONE        ctermbg=NONE        cterm=underline

" Message displayed in lower left, such as --INSERT--
hi ModeMsg          ctermfg=black       ctermbg=cyan        cterm=BOLD

if version >= 700 " Vim 7.x specific colors
  hi CursorLine     ctermfg=NONE        ctermbg=NONE        cterm=BOLD
  hi CursorColumn   ctermfg=NONE        ctermbg=NONE        cterm=BOLD
  hi MatchParen     ctermfg=white       ctermbg=darkgray    cterm=NONE
  hi Pmenu          ctermfg=NONE        ctermbg=darkgray    cterm=NONE
  hi PmenuSel       ctermfg=NONE        ctermbg=NONE        cterm=UNDERLINE
  hi Search         ctermfg=NONE        ctermbg=NONE        cterm=underline
endif

" Syntax highlighting
hi Comment          ctermfg=darkgray    ctermbg=NONE        cterm=NONE
hi String           ctermfg=darkgreen   ctermbg=NONE        cterm=NONE
hi Number           ctermfg=magenta     ctermbg=NONE        cterm=NONE

hi Keyword          ctermfg=lightblue   ctermbg=NONE        cterm=NONE
hi PreProc          ctermfg=lightblue   ctermbg=NONE        cterm=NONE
hi Conditional      ctermfg=lightblue   ctermbg=NONE        cterm=NONE  " if else end

hi Todo             ctermfg=red         ctermbg=NONE        cterm=NONE
hi Constant         ctermfg=magenta     ctermbg=NONE        cterm=NONE

hi Identifier       ctermfg=cyan        ctermbg=NONE        cterm=NONE
hi Function         ctermfg=brown       ctermbg=NONE        cterm=NONE
hi Type             ctermfg=3           ctermbg=NONE        cterm=NONE
hi Statement        ctermfg=blue        ctermbg=NONE        cterm=NONE

hi Special          ctermfg=white       ctermbg=NONE        cterm=NONE
hi Delimiter        ctermfg=cyan        ctermbg=NONE        cterm=NONE
hi Operator         ctermfg=white       ctermbg=NONE        cterm=NONE

hi link Character       Constant
hi link Boolean         Constant
hi link Float           Number
hi link Repeat          Statement
hi link Label           Statement
hi link Exception       Statement
hi link Include         PreProc
hi link Define          PreProc
hi link Macro           PreProc
hi link PreCondit       PreProc
hi link StorageClass    Type
hi link Structure       Type
hi link Typedef         Type
hi link Tag             Special
hi link SpecialChar     Special
hi link SpecialComment  Special
hi link Debug           Special


" Special for Ruby
hi rubyRegexp                  ctermfg=brown          ctermbg=NONE      cterm=NONE
hi rubyRegexpDelimiter         ctermfg=brown          ctermbg=NONE      cterm=NONE
hi rubyEscape                  ctermfg=cyan           ctermbg=NONE      cterm=NONE
hi rubyInterpolationDelimiter  ctermfg=blue           ctermbg=NONE      cterm=NONE
hi rubyControl                 ctermfg=blue           ctermbg=NONE      cterm=NONE  "and break, etc
"hi rubyGlobalVariable          ctermfg=lightblue      ctermbg=NONE      cterm=NONE  "yield
hi rubyStringDelimiter         ctermfg=lightgreen     ctermbg=NONE      cterm=NONE
"rubyInclude
"rubySharpBang
"rubyAccess
"rubyPredefinedVariable
"rubyBoolean
"rubyClassVariable
"rubyBeginEnd
"rubyRepeatModifier
"hi link rubyArrayDelimiter    Special  " [ , , ]
"rubyCurlyBlock  { , , }

hi link rubyClass             Keyword 
hi link rubyModule            Keyword 
hi link rubyKeyword           Keyword 
hi link rubyOperator          Operator
hi link rubyIdentifier        Identifier
hi link rubyInstanceVariable  Identifier
hi link rubyGlobalVariable    Identifier
hi link rubyClassVariable     Identifier
hi link rubyConstant          Type  


" Special for Java
" hi link javaClassDecl    Type
hi link javaScopeDecl         Identifier 
hi link javaCommentTitle      javaDocSeeTag 
hi link javaDocTags           javaDocSeeTag 
hi link javaDocParam          javaDocSeeTag 
hi link javaDocSeeTagParam    javaDocSeeTag 

hi javaDocSeeTag              ctermfg=darkgray    ctermbg=NONE        cterm=NONE
hi javaDocSeeTag              ctermfg=darkgray    ctermbg=NONE        cterm=NONE
"hi javaClassDecl              ctermfg=white       ctermbg=NONE        cterm=NONE


" Special for XML
hi link xmlTag          Keyword 
hi link xmlTagName      Conditional 
hi link xmlEndTag       Identifier 


" Special for HTML
hi link htmlTag         Keyword 
hi link htmlTagName     Conditional 
hi link htmlEndTag      Identifier 


" Special for Javascript
hi link javaScriptNumber      Number 


" Special for Python
"hi  link pythonEscape         Keyword      


" Special for CSharp
hi  link csXmlTag             Keyword      


" Special for PHP
