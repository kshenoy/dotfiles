"" Create generic colorscheme related highlight groups
highlight base16_00 ctermfg=00 guifg=#fdf6e3
highlight base16_03 ctermfg=08 guifg=#839496
highlight base16_05 ctermfg=07 guifg=#586e75
highlight base16_07 ctermfg=15 guifg=#002b36
highlight base16_08 ctermfg=01 guifg=#dc322f
highlight base16_0A ctermfg=03 guifg=#b58900
highlight base16_0B ctermfg=02 guifg=#859900
highlight base16_0C ctermfg=06 guifg=#2aa198
highlight base16_0D ctermfg=04 guifg=#268bd2
highlight base16_0E ctermfg=05 guifg=#6c71c4
if exists("base16colorspace") && base16colorspace == "256"
  highlight base16_01 ctermfg=18 guifg=#eee8d5
  highlight base16_02 ctermfg=19 guifg=#93a1a1
  highlight base16_04 ctermfg=20 guifg=#657b83
  highlight base16_06 ctermfg=21 guifg=#073642
  highlight base16_09 ctermfg=16 guifg=#cb4b16
  highlight base16_0F ctermfg=17 guifg=#d33682
else
  highlight base16_01 ctermfg=10 guifg=#eee8d5
  highlight base16_02 ctermfg=11 guifg=#93a1a1
  highlight base16_04 ctermfg=12 guifg=#657b83
  highlight base16_06 ctermfg=13 guifg=#073642
  highlight base16_09 ctermfg=09 guifg=#cb4b16
  highlight base16_0F ctermfg=14 guifg=#d33682
endif


"" Override colors that I don't like
execute "highlight CursorLineNr guifg=" . utils#GetHighlightInfo('base16_0F').guifg
highlight StatusLineNC guibg=#d0d0c4

"" Column number
highlight clear STLColumn
let s:stl_column=utils#GetHighlightInfo('StatusLine')
let s:stl_column.guifg=utils#GetHighlightInfo('base16_0D').guifg
call utils#SetHighlightInfo('STLColumn', s:stl_column)

"" Background color of HELP text for help related buffer
highlight clear STLHelp
highlight STLHelp guifg=#fdf6e3 guibg=#dc322f

"" Decoration around filename and filetype
highlight clear STLMarker
let s:stl_marker = { 'guibg': utils#GetHighlightInfo('StatusLine').guibg }
let s:stl_marker.guifg = '#2aa198'
call utils#SetHighlightInfo('STLMarker', s:stl_marker)

highlight clear STLFilename
let s:stl_filename=utils#GetHighlightInfo('StatusLine')
let s:stl_filename.gui='bold'
call utils#SetHighlightInfo('STLFilename', s:stl_filename)

"" Status: Modified, Read Only, Paste, Spell etc.
highlight clear STLStatus
highlight STLStatus guifg=#d33682 guibg=#eee8d5


"" Cursor highlights
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


" vim-signature settings
highlight! link SignatureMarkText   CursorLineNr
highlight! link SignatureMarkerText CursorLineNr


" vim-mark
let g:mwPalettes['solarized'] = [
  \ { 'ctermbg' : utils#GetHighlightInfo('base16_09').ctermfg, 'guibg' : utils#GetHighlightInfo('base16_09').guifg },
  \ { 'ctermbg' : utils#GetHighlightInfo('base16_0B').ctermfg, 'guibg' : utils#GetHighlightInfo('base16_0B').guifg },
  \ { 'ctermbg' : utils#GetHighlightInfo('base16_0D').ctermfg, 'guibg' : utils#GetHighlightInfo('base16_0D').guifg },
  \ { 'ctermbg' : utils#GetHighlightInfo('base16_0A').ctermfg, 'guibg' : utils#GetHighlightInfo('base16_0A').guifg },
  \ { 'ctermbg' : utils#GetHighlightInfo('base16_0F').ctermfg, 'guibg' : utils#GetHighlightInfo('base16_0F').guifg },
  \ { 'ctermbg' : utils#GetHighlightInfo('base16_0C').ctermfg, 'guibg' : utils#GetHighlightInfo('base16_0C').guifg },
  \ { 'ctermbg' : utils#GetHighlightInfo('base16_0E').ctermfg, 'guibg' : utils#GetHighlightInfo('base16_0E').guifg },
  \ { 'ctermbg' : utils#GetHighlightInfo('base16_02').ctermfg, 'guibg' : utils#GetHighlightInfo('base16_02').guifg },
  \ ]
MarkPalette solarized
