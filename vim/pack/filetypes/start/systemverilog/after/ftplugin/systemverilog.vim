" The default value of b:match_words matches everywhere. I want to modify it to only match at the start of the line
" The following code replaces the `ifdef clause with one that includes them.
if exists("b:match_words") && match(b:match_words, '`if')
  " Remove the original definition
  let b:match_words = substitute(b:match_words, '`if.\{-},', '', '')

  " Add the new one
  let s:sol = '\%(^\s*\)\@<='
  let b:match_words .= ',' . s:sol . '`if\%[n]def\>:' . s:sol . '`els\%(if\|e\)\>:' . s:sol . '`endif\>'

  " Clean-up - Remove any duplicate commas
  let b:match_words = substitute(b:match_words, '\v,(\s*,)*', '', '')
endif

