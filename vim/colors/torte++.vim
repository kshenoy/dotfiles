" Vim color file
" Maintainer  : Kartik Shenoy
" Last Change : 2009-11-10
" Modification of original 'torte' colorscheme by Thorsten Maerz <info@netztorte.de>
"
" Changelog :
"
" 2009-11-10:
"    Changed line number to guifg=LightYellow
"    Changed FoldColumn to guibg=Black guifg=Grey85 gui=bold
"    Changed Folded to guifg=Grey15 guibg=Grey70 gui=bold
"    Changed Comment to gui=italic

set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
"colorscheme default
let g:colors_name = "torte++"

" hardcoded colors :
" GUI Comment : #80a0ff = Light blue

" Vim >= 7.0 specific colors
if version >= 700
  "hi CursorLine     guibg=#2d2d2d
  "hi CursorColumn   guibg=#2d2d2d
  hi MatchParen     guifg=#f6f3e8   guibg=#857b6f   gui=bold
  hi Pmenu          guifg=#ffffff   guibg=#333333
  hi PmenuSel       guifg=#000000   guibg=#80a0ff   gui=bold
endif

" GUI
highlight Normal        guifg=Grey80        guibg=Black
highlight Search        guifg=Black         guibg=Red       gui=bold
highlight Visual        guifg=Grey25                        gui=bold
highlight Cursor        guifg=Black         guibg=Green     gui=bold
highlight Special       guifg=Orange
highlight Comment       guifg=#80a0ff                       gui=italic
highlight StatusLine    guifg=blue          guibg=white
highlight Statement     guifg=Yellow                        gui=NONE
highlight Type                                              gui=NONE
highlight Folded        guifg=Grey80        guibg=#0e0e0e
highlight FoldColumn    guifg=Grey80        guibg=Grey5    gui=bold
highlight LineNr        guifg=LightYellow   guibg=Black    

" Console
highlight Normal        ctermfg=LightGrey   ctermbg=Black
highlight Search        ctermfg=Black       ctermbg=Red     cterm=NONE
highlight Visual                                            cterm=reverse
highlight Cursor        ctermfg=Black       ctermbg=Green   cterm=bold
highlight Special       ctermfg=Brown
highlight Comment       ctermfg=Blue
highlight StatusLine    ctermfg=blue        ctermbg=white
highlight Statement     ctermfg=Yellow                      cterm=NONE
highlight Type                                              cterm=NONE

" only for vim 5
if has("unix")
  if v:version<600
    highlight Normal    ctermfg=Grey        ctermbg=Black       cterm=NONE    guifg=Grey80      guibg=Black     gui=NONE
    highlight Search    ctermfg=Black       ctermbg=Red         cterm=bold    guifg=Black       guibg=Red       gui=bold
    highlight Visual    ctermfg=Black       ctermbg=yellow      cterm=bold    guifg=Grey25                      gui=bold
    highlight Special   ctermfg=LightBlue                       cterm=NONE    guifg=LightBlue                   gui=NONE
    highlight Comment   ctermfg=Cyan                            cterm=NONE    guifg=LightBlue                   gui=NONE
  endif
endif

