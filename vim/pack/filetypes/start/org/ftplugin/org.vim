"
" 16. FOLDING                                                                                                       {{{1
"
function! org#FoldExpr(lnum)
  let l:line=getline(a:lnum)

  " Start a new fold at a heading
  if l:line =~ '\v^\*+ '
    return ">" . len(matchlist(l:line, '\v^\s*(\*+)\s+')[1])
  endif

  " Fold source blocks by nesting them inside the current fold-level
  " if l:line =~ '\v^\s*#\+BEGIN_'
  "   return "a1"
  " elseif l:line =~ '\v^\s*#\+END_'
  "   return "s1"
  " endif

  return "="
endfunction

if !&diff
  set foldmethod=expr
  set foldexpr=org#FoldExpr(v:lnum)
endif
