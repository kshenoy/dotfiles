" Use the DD command to search on devdocs.io
" From: https://gist.github.com/romainl/8d3b73428b4366f75a19be2dad2f0987
"
" SYNTAX:
"
" Use :DD without argument to look up the word under the cursor, scoped with the current filetype:
" :DD

" Use :DD keyword to look up the given keyword, scoped with the current filetype:
" :DD Map

" Use :DD scope keyword to do the scoping yourself:
" :DD scss @mixin

" Use the :DD command for keyword look up with the built-in K:
" setlocal keywordprg=:DD


if g:env ==? 'darwin'
  let s:cmd = "open"
endif

if g:env ==? 'linux'
  let s:cmd = "xdg-open"
endif

if g:env ==? 'windows'
  let s:cmd = "start"
endif

let s:cmd = s:cmd . " 'http://devdocs.io/#q="

command! -nargs=* DD silent system(
\ ( len(split(<q-args>, ' '))  == 0
\ ? s:cmd . &ft . ' ' . expand('<cword>') . "'"
\ : ( len(split(<q-args>, ' ')) == 1
\   ? s:cmd . &ft . ' ' . <q-args> . "'"
\   : stub . <q-args> . "'"
\   )
\ )
\)


augroup DevDocs
  autocmd!
  autocmd FileType c,perl,ruby,python,gitconfig setlocal keywordprg=:DD
augroup END
