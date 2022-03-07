"
" 15. TABS AND INDENTING
"
setl noautoindent                                                                                " Auto-indent new lines
setl cindent                                                                      " Enable specific indenting for C code


"
" 22. EXECUTING EXTERNAL COMMANDS
"
if &formatprg == ""
  setl formatprg=clang-format\ --style=google
endif


"
" 23. RUNNING MAKE AND JUMPING TO ERRORS
"
setl makeprg=clang++\ -std=c++14\ -static-libstdc++\ -Wall\ -Wextra\ -Werror\ -L$LLVM_HOME/lib\ -L$BOOST_HOME/lib\ -I$BOOST_HOME/include\ -Wl,-rpath\ $BOOST_HOME/lib\ -L$HOME/.local/lib\ -I$HOME/.local/include\ -o\ %:r\ %


"
" 24. LANGUAGE SPECIFIC
"
setl isk-=:


"
" PLUGIN SETTINGS
"
call add(g:switch_custom_definitions, [ '::', '.', '->' ])
