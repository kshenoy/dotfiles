if !exists(':Tabularize')
  finish " Tabular.vim wasn't loaded
endif

" Tabular pattern to align words in a column
" Convert this ...
"   abc   def ghi
"   jkl mno    pqr
"   stu  vwx  yz
" to this...
"   abc def ghi
"   jkl mno pqr
"   stu vwx yz
AddTabularPipeline! align_words / \+/
  \ map(a:lines, "substitute(v:val, '\\v^@! +', ' ', 'g')")
  \ | tabular#TabularizeStrings(a:lines, ' ', 'l0')

AddTabularPipeline! align_braces /\v(^[^(]*\zs\()|(\)\ze[^)]*$)/
  \   tabular#TabularizeStrings(a:lines, '\v^[^(]*\zs\(', 'l0r' . nr2char(getchar()))
  \ | tabular#TabularizeStrings(a:lines, '\v\)\ze[^)]*$', 'l' . nr2char(getchar()) . 'r0')

AddTabularPipeline! align_curly_braces /\v(^[^{]*\zs\{)|(\}\ze[^}]*$)/
  \   tabular#TabularizeStrings(a:lines, '\v^[^(]*\zs\(', 'l0r0')
  \ | tabular#TabularizeStrings(a:lines, '\v\)\ze[^)]*$', 'l0r0')
