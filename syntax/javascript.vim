" Vim syntax file
" Language:     JavaScript
" Maintainer:   Yi Zhao <zzlinux AT hotmail DOT com>
" Last Change:  2006 Oct. 25
" Version:      0.6.7
" Based On:     javascript.vim from Claudio Fleiner <claudio AT fleiner.com>
" Changes:      JSDoc parameter do recogonize "#.:/" at any position.
"               The "$" can appear at any position of the function name.
"               The continous line comments will be folding in fold mode.
"
"
" TODO:
"  - Add the HTML syntax inside the JSDoc

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'javascript'
endif

" Drop fold if it set but vim doesn't support it.
if version < 600 && exists("javaScript_fold")
  unlet javaScript_fold
else
  let javaScript_fold = 'false'
endif

"" dollar sigh is permittd anywhere in an identifier
setlocal iskeyword+=$

syntax sync fromstart
syntax sync maxlines=200

"" JavaScript comments
syntax keyword javaScriptCommentTodo    TODO FIXME XXX TBD contained
syntax region  javaScriptLineComment    start=+\/\/+ skip=+\_s\+\/\/+ end=/$/ contains=javaScriptCommentTodo,@Spell fold
syntax region  javaScriptCvsTag         start="\$\cid:" end="\$" oneline contained
syntax region  javaScriptComment        start="/\*"  end="\*/" contains=javaScriptCommentTodo,javaScriptLineComment,javaScriptCvsTag,@Spell fold

"" JSDoc support start
if !exists("javascript_ignore_javaScriptdoc")
  syntax case ignore

  " syntax coloring for javadoc comments (HTML)
  "syntax include @javaHtml <sfile>:p:h/html.vim
  "unlet b:current_syntax  
  
  syntax region javaScriptDocComment    matchgroup=javaScriptComment start="/\*\*\s*$"  end="\*/" contains=javaScriptDocTags,javaScriptDocSeeTag,javaScriptCommentTodo,javaScriptCvsTag,@javaScriptHtml,@Spell fold
  syntax match  javaScriptDocTags       contained "@\(param\|argument\|requires\|exception\|throws\|type\|class\|extends\|see\|link\|member\|base\|file\)\>" nextgroup=javaScriptDocParam skipwhite
  syntax match  javaScriptDocTags       contained "@\(deprecated\|fileoverview\|author\|license\|version\|returns\=\|constructor\|private\|final\|ignore\|addon\|exec\)\>"
  syntax match  javaScriptDocParam      contained "\%(#\|\w\|\.\|:\|\/\)\+"
  syntax region javaScriptDocSeeTag     contained matchgroup=javaScriptDocSeeTag start="{" end="}" contains=javaScriptDocTags

  syntax case match
endif   "" JSDoc end

syntax case match

"" Syntax in the JavaScript code
syntax match   javaScriptSpecial        "\\\d\d\d\|\\x[0-9a-fA-F]\{2\}\|\\u[0-9a-fA-F]\{4\}\|\\."
syntax region  javaScriptStringD        start=+"+  skip=+\\\\\|\\$"+  end=+"+  contains=javaScriptSpecial,@htmlPreproc
syntax region  javaScriptStringS        start=+'+  skip=+\\\\\|\\$'+  end=+'+  contains=javaScriptSpecial,@htmlPreproc
syntax region  javaScriptRegexpString   start=+/\(\*\|/\)\@!+ skip=+\\\\\|\\/+ end=+/[gim]\{-,3}\(\s*[),.;$]\)\@=+ contains=javaScriptSpecial,@htmlPreproc oneline
syntax match   javaScriptNumber         /\<-\=\d\+L\=\>\|\<0[xX]\x\+\>/
syntax match   javaScriptFloat          /\<-\=\%(\d\+\.\d\+\|\d\+\.\|\.\d\+\)\%([eE][+-]\=\d\+\)\=\>/
syntax match   javaScriptLabel          /\(?\s*\)\@<!\<\w\+\(\s*:\)\@=/

"" JavaScript Prototype 
syntax match   javaScriptPrototype      "\.prototype\>"

"" Programm Keywords
syntax keyword javaScriptSource         import export
syntax keyword javaScriptType           this var const void 
syntax keyword javaScriptOperator       delete new in instanceof typeof 
syntax keyword javaScriptBoolean        true false
syntax keyword javaScriptNull           null

"" Statement Keywords
syntax keyword javaScriptConditional    if else
syntax keyword javaScriptRepeat         do while for
syntax keyword javaScriptBranch         break continue switch case default return 
syntax keyword javaScriptStatement      try catch throw with finally 

syntax keyword javaScriptGlobalObjects  Array Boolean Date Error Function java JavaArray JavaClass JavaObject JavaPackage Math netscape Number NaN Object Packages RegExp String sun

"" Code blocks
syntax cluster javaScriptAll       contains=javaScriptComment,javaScriptLineComment,javaScriptDocComment,javaScriptStringD,javaScriptStringS,javaScriptRegexpString,javaScriptNumber,javaScriptFloat,javaScriptLabel,javaScriptPrototype,javaScriptSource,javaScriptType,javaScriptOperator,javaScriptBoolean,javaScriptNull,javaScriptFunction,javaScriptConditional,javaScriptRepeat,javaScriptBranch,javaScriptStatement,javaScriptGlobalObjects
syntax region  javaScriptBracket   matchgroup=javaScriptBracket transparent start="\[" end="\]" contains=@javaScriptAll,javaScriptParensErrB,javaScriptParensErrC,javaScriptBracket,javaScriptParen,javaScriptBlock,@htmlPreproc
syntax region  javaScriptParen     matchgroup=javaScriptParen   transparent start="("  end=")"  contains=@javaScriptAll,javaScriptParensErrA,javaScriptParensErrC,javaScriptParen,javaScriptBracket,javaScriptBlock,@htmlPreproc
syntax region  javaScriptBlock     matchgroup=javaScriptBlock   transparent start="{"  end="}"  contains=@javaScriptAll,javaScriptParensErrA,javaScriptParensErrB,javaScriptParen,javaScriptBracket,javaScriptBlock,@htmlPreproc

"" catch errors caused by wrong parenthesis
syntax match   javaScriptParensError    ")\|}\|\]"
syntax match   javaScriptParensErrA     contained "\]"
syntax match   javaScriptParensErrB     contained ")"
syntax match   javaScriptParensErrC     contained "}"

if main_syntax == "javascript"
  syntax sync ccomment javaScriptComment
endif

"" Fold control
if exists("javaScript_fold")
    syntax match   javaScriptFunction       /\<function\>/ nextgroup=javaScriptFuncName skipwhite 
    syntax region  javaScriptFuncName       contained matchgroup=javaScriptFuncName start=/\%(\$\|\w\)*\s*(/ end=/)/ contains=javaScriptLineComment,javaScriptComment nextgroup=javaScriptFuncBlock skipwhite skipempty
    syntax region  javaScriptFuncBlock      contained matchgroup=javaScriptFuncBlock start="{" end="}" contains=@javaScriptAll,javaScriptParensErrA,javaScriptParensErrB,javaScriptParen,javaScriptBracket,javaScriptBlock fold

    "" Fold setting
    setlocal foldlevel=3
    setlocal foldmethod=syntax

    setlocal foldtext=FT_JavaScriptDoc()

    "" Default fold text for JavaScript JSDoc and Function
    function FT_JavaScriptDoc()
      let i = 0
      while i < 3
        let line = getline(v:foldstart + i)
        "let line = substitute(line, '^\s\+', '', '')
        let line = substitute(line, '\s\+$', '', '')
        if match(line, '\w\+') >= 0 
          break
        endif
        let i += 1
      endwhile
      return v:folddashes . line
    endfunction

else
    syntax keyword javaScriptFunction       function
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_javascript_syn_inits")
  if version < 508
    let did_javascript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink javaScriptComment              Comment
  HiLink javaScriptLineComment          Comment
  HiLink javaScriptDocComment           Comment
  HiLink javaScriptCommentTodo          Todo
  HiLink javaScriptCvsTag               Function
  HiLink javaScriptDocTags              Special
  HiLink javaScriptDocSeeTag            Function
  HiLink javaScriptDocParam             Function
  HiLink javaScriptStringS              String
  HiLink javaScriptStringD              String
  HiLink javaScriptRegexpString         String
  HiLink javaScriptCharacter            Character
  HiLink javaScriptPrototype            Type
  HiLink javaScriptConditional          Conditional
  HiLink javaScriptBranch               Conditional
  HiLink javaScriptRepeat               Repeat
  HiLink javaScriptStatement            Statement
  HiLink javaScriptFunction             Function
  HiLink javaScriptError                Error
  HiLink javaScriptParensError          Error
  HiLink javaScriptParensErrA           Error
  HiLink javaScriptParensErrB           Error
  HiLink javaScriptParensErrC           Error
  HiLink javaScriptOperator             Operator
  HiLink javaScriptType                 Type
  HiLink javaScriptNull                 Type
  HiLink javaScriptNumber               Number
  HiLink javaScriptFloat                Number
  HiLink javaScriptBoolean              Boolean
  HiLink javaScriptLabel                Label
  HiLink javaScriptSpecial              Special
  HiLink javaScriptSource               Special
  HiLink javaScriptGlobalObjects        Special
  delcommand HiLink
endif

" Define the htmlJavaScript for HTML syntax html.vim
syntax cluster  htmlJavaScript contains=@javaScriptAll,javaScriptBracket,javaScriptParen,javaScriptBlock,javaScriptParenError
syntax cluster  javaScriptExpression contains=@javaScriptAll,javaScriptBracket,javaScriptParen,javaScriptBlock,javaScriptParenError,@htmlPreproc

let b:current_syntax = "javascript"
if main_syntax == 'javascript'
  unlet main_syntax
endif

" vim: ts=4
