" The default value of b:match_words is missing `ifndef and `elsif
" The following code replaces the `ifdef clause with one that includes them.
if exists("b:match_words") && match(b:match_words, '`if')
  " Remove the incomplete definition
  let b:match_words = substitute(b:match_words, '`if.\{-},', '', '')
  " Add the complete one
  let b:match_words .= ',`\%(if\|ifdef\|ifndef\)\>:`els\%(if\|e\)\>:`endif\>'
  let b:match_words .= ',`for:`endfor'
  " Clean-up - Remove any duplicate commas
  let b:match_words = substitute(b:match_words, '\v,(\s*,)*', '', '')
endif
