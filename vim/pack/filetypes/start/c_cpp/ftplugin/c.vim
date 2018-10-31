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
setl formatprg=clang-format\ --style=file


"
" 23. RUNNING MAKE AND JUMPING TO ERRORS
"
setl makeprg=g++\ -std=c++14\ -o\ %:r\ %


"
" 24. LANGUAGE SPECIFIC
"
setl isk-=:


"
" PLUGIN SETTINGS
"
call add(g:switch_custom_definitions, [ '.', '->' ])
