"
" 15. TABS AND INDENTING
"
set noautoindent                                                                                 " Auto-indent new lines
set cindent                                                                       " Enable specific indenting for C code


"
" 16. FOLDING
"
set commentstring=//\ %s


"
" 22. EXECUTING EXTERNAL COMMANDS
"
set formatprg=clang-format\ --style=file                                                        " Set formatting program


"
" 24. LANGUAGE SPECIFIC
"
set isk-=:
