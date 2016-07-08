" Switch settings for taking notes
let g:switch_find_smallest_match = 0
"let g:switch_custom_definitions = [ {'\*':   '\* ✔'},
"                                \   {'\* ✔': '\* ✗'},
"                                \   {'\* ✗': '\*'},
"                                \ ]
let g:switch_custom_definitions = [ {'\*' : '\[ \]'},
                                \   {'\[ \]': '\[x\]'},
                                \   {'\[x\]': '\*'},
                                \ ]
