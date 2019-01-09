"
" 15. TABS AND INDENTING
"
setl noautoindent                                                                                " Auto-indent new lines
setl cindent                                                                      " Enable specific indenting for C code


"
" 16. FOLDING
"
setl commentstring=//\ %s


"
" 22. EXECUTING EXTERNAL COMMANDS
"
if &formatprg == ""
  setl formatprg=clang-format\ --style=google
endif


"
" 23. RUNNING MAKE AND JUMPING TO ERRORS
"
setl makeprg=clang++\ -Wall\ -Wextra\ -std=c++14\ -L$HOME/.local/lib\ -I$HOME/.local/include\ -o\ %:r\ %


"
" 24. LANGUAGE SPECIFIC
"
setl isk-=:


"
" PLUGIN SETTINGS
"
call add(g:switch_custom_definitions, [ '.', '->' ])
