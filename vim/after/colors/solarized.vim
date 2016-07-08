highlight clear STLColumn
let s:stl_column=my#GetHighLightInfo('StatusLine')
let s:stl_column.guifg="#268bd2"
call my#SetHighLightInfo('STLColumn', s:stl_column)

highlight clear STLHelp
highlight STLHelp guifg=#fdf6e3 guibg=#dc322f

highlight clear STLMarker
highlight STLMarker guifg=#2aa198 guibg=#eee8d5

highlight clear STLFilename
let s:stl_filename=my#GetHighLightInfo('StatusLine')
let s:stl_filename.gui="bold"
call my#SetHighLightInfo('STLFilename', s:stl_filename)

highlight clear STLStatus
highlight STLStatus guifg=#d33682 guibg=#eee8d5

highlight NormalCursor  guifg=#fdf6e3 guibg=#719e07
highlight InsertCursor  guifg=#fdf6e3 guibg=#268bd2
highlight ReplaceCursor guifg=#fdf6e3 guibg=#dc322f
highlight VisualCursor  guifg=#fdf6e3 guibg=#b58900
highlight CommandCursor guifg=#fdf6e3 guibg=#d33682
