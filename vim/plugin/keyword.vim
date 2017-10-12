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
elseif g:env ==? 'linux'
  let s:cmd = "xdg-open"
elseif g:env ==? 'windows'
  let s:cmd = "start"
endif


let s:dd_cmd = s:cmd . " 'http://devdocs.io/#q="
command! -nargs=* DD silent call system(
\ ( len(split(<q-args>, ' ')) == 0
\ ? s:dd_cmd . &ft . ' ' . expand('<cword>')
\ : ( len(split(<q-args>, ' ')) == 1
\   ? s:dd_cmd . &ft . ' ' . <q-args>
\   : s:dd_cmd . <q-args>
\   )
\ ) . "'"
\)


let s:cpp_cmd = s:cmd . " 'http://en.cppreference.com/mwiki/index.php?title=Special%3ASearch&search="
command! -nargs=? CPP silent call system(
\ ( len(split(<q-args>, ' ')) == 0
\ ? s:cpp_cmd . expand('<cword>')
\ : s:cpp_cmd . <q-args>
\ ) . "'"
\)


let s:goog_cmd = s:cmd . " 'https://www.google.com/search?q="
command! -nargs=* GOOG silent call system(
\ ( len(split(<q-args>, ' ')) == 0
\ ? s:goog_cmd . expand('<cword>')
\ : s:goog_cmd . <q-args>
\ ) . "'"
\)
nnoremap gK :GOOG<CR>


augroup DevReference
  autocmd!
  autocmd FileType perl,ruby,python,gitconfig setlocal keywordprg=:DD
  autocmd FileType c,cpp                      setlocal keywordprg=:CPP
  autocmd FileType vim                        setlocal keywordprg=:vert\ bo\ help
augroup END
