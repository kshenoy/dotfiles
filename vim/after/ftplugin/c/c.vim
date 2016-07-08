" Let the matchit plugin know what items can be matched.
if exists("loaded_matchit")
  let b:match_ignorecase=0
  let b:match_words .=
        \ ',\<if\>:\<else\>' .
        \ ',\<switch\>:\<case\>:\<default\>' .
        \ ',\<do\>:\<while\>'
endif
