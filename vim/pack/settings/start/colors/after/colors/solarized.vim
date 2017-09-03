highlight clear STLColumn
let s:stl_column=utils#GetHighlightInfo('StatusLine')
let s:stl_column.guifg="#268bd2"
call utils#SetHighlightInfo('STLColumn', s:stl_column)

highlight clear STLHelp
highlight STLHelp guifg=#fdf6e3 guibg=#dc322f

highlight clear STLMarker
highlight STLMarker guifg=#2aa198 guibg=#eee8d5

highlight clear STLFilename
let s:stl_filename=utils#GetHighlightInfo('StatusLine')
let s:stl_filename.gui="bold"
call utils#SetHighlightInfo('STLFilename', s:stl_filename)

highlight clear STLStatus
highlight STLStatus guifg=#d33682 guibg=#eee8d5

highlight NormalCursor  guifg=#fdf6e3 guibg=#719e07
highlight InsertCursor  guifg=#fdf6e3 guibg=#268bd2
highlight ReplaceCursor guifg=#fdf6e3 guibg=#dc322f
highlight VisualCursor  guifg=#fdf6e3 guibg=#b58900
highlight CommandCursor guifg=#fdf6e3 guibg=#d33682

" ale related settings
let s:sign_column_bg=utils#GetHighlightInfo('SignColumn').guibg
let s:ale_sign=utils#GetHighlightInfo('Error')
let s:ale_sign.guibg=s:sign_column_bg
call utils#SetHighlightInfo('ALEErrorSign', s:ale_sign)
let s:ale_sign=utils#GetHighlightInfo('Todo')
let s:ale_sign.guibg=s:sign_column_bg
call utils#SetHighlightInfo('ALEWarningSign', s:ale_sign)
