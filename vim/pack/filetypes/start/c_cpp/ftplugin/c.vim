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
setl formatprg=/tool/pandora64/.package/llvm-4.0.0-gcc630/bin/clang-format\ --style=file


"
" 24. LANGUAGE SPECIFIC
"
setl isk-=: