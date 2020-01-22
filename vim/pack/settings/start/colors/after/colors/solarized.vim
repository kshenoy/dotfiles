"" Create generic colorscheme related highlight groups
highlight base16_00_fg ctermfg=00 guifg=#fdf6e3
highlight base16_03_fg ctermfg=08 guifg=#839496
highlight base16_05_fg ctermfg=07 guifg=#586e75
highlight base16_07_fg ctermfg=15 guifg=#002b36
highlight base16_08_fg ctermfg=01 guifg=#dc322f
highlight base16_0A_fg ctermfg=03 guifg=#b58900
highlight base16_0B_fg ctermfg=02 guifg=#859900
highlight base16_0C_fg ctermfg=06 guifg=#2aa198
highlight base16_0D_fg ctermfg=04 guifg=#268bd2
highlight base16_0E_fg ctermfg=05 guifg=#6c71c4
if exists("base16colorspace") && base16colorspace == "256"
  highlight base16_01_fg ctermfg=18 guifg=#eee8d5
  highlight base16_02_fg ctermfg=19 guifg=#93a1a1
  highlight base16_04_fg ctermfg=20 guifg=#657b83
  highlight base16_06_fg ctermfg=21 guifg=#073642
  highlight base16_09_fg ctermfg=16 guifg=#cb4b16
  highlight base16_0F_fg ctermfg=17 guifg=#d33682
else
  highlight base16_01_fg ctermfg=10 guifg=#eee8d5
  highlight base16_02_fg ctermfg=11 guifg=#93a1a1
  highlight base16_04_fg ctermfg=12 guifg=#657b83
  highlight base16_06_fg ctermfg=13 guifg=#073642
  highlight base16_09_fg ctermfg=09 guifg=#cb4b16
  highlight base16_0F_fg ctermfg=14 guifg=#d33682
endif

for color in ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '0A', '0B', '0C', '0D', '0E', '0F']
  execute "highlight base16_" . color . "_bg ctermbg=" . utils#GetHighlightInfo('base16_' . color . '_fg').ctermfg . " ctermfg=" . utils#GetHighlightInfo('Normal').ctermbg . " guibg=" . utils#GetHighlightInfo('base16_' . color . '_fg').guifg . " guifg=" . utils#GetHighlightInfo('Normal').guibg
endfor


"" Override colors that I don't like
execute "highlight CursorLineNr guifg=" . utils#GetHighlightInfo('base16_0F_fg').guifg
highlight StatusLineNC guibg=#d0d0c4

"" Column number
highlight clear STLColumn
let s:stl_column=utils#GetHighlightInfo('StatusLine')
let s:stl_column.guifg=utils#GetHighlightInfo('base16_0D_fg').guifg
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
  \ { 'ctermbg' : utils#GetHighlightInfo('base16_09_bg').ctermbg, 'guibg' : utils#GetHighlightInfo('base16_09_bg').guibg,
  \   'ctermfg' : utils#GetHighlightInfo('base16_01_fg').ctermfg, 'guifg' : utils#GetHighlightInfo('base16_01_fg').guifg },
  \ { 'ctermbg' : utils#GetHighlightInfo('base16_0B_bg').ctermbg, 'guibg' : utils#GetHighlightInfo('base16_0B_bg').guibg,
  \   'ctermfg' : utils#GetHighlightInfo('base16_01_fg').ctermfg, 'guifg' : utils#GetHighlightInfo('base16_01_fg').guifg },
  \ { 'ctermbg' : utils#GetHighlightInfo('base16_0D_bg').ctermbg, 'guibg' : utils#GetHighlightInfo('base16_0D_bg').guibg,
  \   'ctermfg' : utils#GetHighlightInfo('base16_01_fg').ctermfg, 'guifg' : utils#GetHighlightInfo('base16_01_fg').guifg },
  \ { 'ctermbg' : utils#GetHighlightInfo('base16_0A_bg').ctermbg, 'guibg' : utils#GetHighlightInfo('base16_0A_bg').guibg,
  \   'ctermfg' : utils#GetHighlightInfo('base16_01_fg').ctermfg, 'guifg' : utils#GetHighlightInfo('base16_01_fg').guifg },
  \ { 'ctermbg' : utils#GetHighlightInfo('base16_0F_bg').ctermbg, 'guibg' : utils#GetHighlightInfo('base16_0F_bg').guibg,
  \   'ctermfg' : utils#GetHighlightInfo('base16_01_fg').ctermfg, 'guifg' : utils#GetHighlightInfo('base16_01_fg').guifg },
  \ { 'ctermbg' : utils#GetHighlightInfo('base16_0C_bg').ctermbg, 'guibg' : utils#GetHighlightInfo('base16_0C_bg').guibg,
  \   'ctermfg' : utils#GetHighlightInfo('base16_01_fg').ctermfg, 'guifg' : utils#GetHighlightInfo('base16_01_fg').guifg },
  \ { 'ctermbg' : utils#GetHighlightInfo('base16_0E_bg').ctermbg, 'guibg' : utils#GetHighlightInfo('base16_0E_bg').guibg,
  \   'ctermfg' : utils#GetHighlightInfo('base16_01_fg').ctermfg, 'guifg' : utils#GetHighlightInfo('base16_01_fg').guifg },
  \ { 'ctermbg' : utils#GetHighlightInfo('base16_02_bg').ctermbg, 'guibg' : utils#GetHighlightInfo('base16_02_bg').guibg,
  \   'ctermfg' : utils#GetHighlightInfo('base16_01_fg').ctermfg, 'guifg' : utils#GetHighlightInfo('base16_01_fg').guifg },
  \ ]
