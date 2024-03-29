" The default value of b:match_words is missing `ifndef and `elsif and also matches everywhere.
" I want to add those and update it to only match at the beginning of the line
" The following code replaces the `ifdef clause with one that includes them.
if exists("b:match_words") && match(b:match_words, '`if')
  " Remove the incomplete definition
  let b:match_words = substitute(b:match_words, '`if.\{-},', '', '')

  " Add the complete one
  let s:sol = '\%(^\s*\)\@<='
  let b:match_words .= ',' . s:sol . '`if\%[n]def\>:' . s:sol . '`els\%(if\|e\)\>:' . s:sol . '`endif\>'
  let b:match_words .= ',' . s:sol . '`for:' . s:sol . '`endfor'

  " Clean-up - Remove any duplicate commas
  let b:match_words = substitute(b:match_words, '\v,(\s*,)*', '', '')
endif
