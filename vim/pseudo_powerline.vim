" stlusline modifications, added Fugitive stlus Line & Syntastic Error Message

function! StlMode() "              {{{1
  let l:mode = mode()

  if !exists('g:mode_last') || l:mode != g:mode_last
    let g:last_mode = l:mode

    " When paste is set, in all modes, stl_mode_arrow will have orange bg and when paste is not set,
    " it will be grey in all modes except insert
    if &paste
      highlight stl_mode_arrow                            ctermbg=166                           guibg=#D75F00
    else
      highlight stl_mode_arrow                            ctermbg=240                           guibg=#585858
    endif
      highlight link stl_ft_arrow stl_file_arrow
      highlight stl_paste        cterm=BOLD  ctermfg=231  ctermbg=166  gui=BOLD  guifg=#FFFFFF  guibg=#D75F00
      highlight stl_paste_arrow              ctermfg=166  ctermbg=240            guifg=#D75F00  guibg=#585858
      "highlight stl_vcs_unknown  cterm=NONE  ctermfg=196  ctermbg=240  gui=NONE  guifg=#FF0000  guibg=#585858
      "highlight stl_vcs_mod      cterm=BOLD  ctermfg=220  ctermbg=240  gui=BOLD  guifg=#FFD700  guibg=#585858
      highlight stl_file_ro      cterm=NONE  ctermfg=196  ctermbg=240  gui=NONE  guifg=#FF0000  guibg=#585858
      highlight stl_file         cterm=BOLD  ctermfg=231  ctermbg=240  gui=BOLD  guifg=#FFFFFF  guibg=#585858
      highlight stl_file_mod     cterm=BOLD  ctermfg=220  ctermbg=240  gui=BOLD  guifg=#FFD700  guibg=#585858
      highlight stl_file_arrow               ctermfg=240  ctermbg=236            guifg=#585858  guibg=#303030
      highlight stl_ft_info                  ctermfg=236  ctermbg=244            guifg=#808080  guibg=#303030
      highlight stl_per          cterm=NONE  ctermfg=250  ctermbg=240  gui=NONE  guifg=#BCBCBC  guibg=#585858
      highlight stl_per_arrow    cterm=NONE  ctermfg=252  ctermbg=240  gui=NONE  guifg=#D0D0D0  guibg=#585858
      highlight stl_line_sym     cterm=NONE  ctermfg=235  ctermbg=252  gui=NONE  guifg=#262626  guibg=#D0D0D0
      highlight stl_line         cterm=BOLD  ctermfg=235  ctermbg=252  gui=BOLD  guifg=#262626  guibg=#D0D0D0
      highlight stl_col          cterm=NONE  ctermfg=22   ctermbg=252  gui=NONE  guifg=#025F00  guibg=#D0D0D0
      highlight stl_bufnr        cterm=NONE  ctermfg=235  ctermbg=252  gui=NONE  guifg=#585858  guibg=#D0D0D0
      highlight stl_ws_arrow     cterm=NONE  ctermfg=160  ctermbg=252  gui=NONE  guifg=#D70000  guibg=#D0D0D0
      highlight stl_ws           cterm=BOLD  ctermfg=231  ctermbg=160  gui=BOLD  guifg=#FFFFFF  guibg=#D70000

    if l:mode ==# "i"
      highlight stl_mode         cterm=BOLD  ctermfg=23   ctermbg=231  gui=BOLD  guifg=#005F5F  guibg=#FFFFFF
      highlight stl_mode_arrow               ctermfg=231                         guifg=#FFFFFF
      if !&paste
        highlight stl_mode_arrow                          ctermbg=31                            guibg=#0087AF
      endif
      highlight stl_paste_arrow              ctermfg=166  ctermbg=31             guifg=#D75F00  guibg=#0087AF
      "highlight stl_vcs_unknown  cterm=NONE  ctermfg=196  ctermbg=240  gui=NONE  guifg=#FF0000  guibg=#585858
      "highlight stl_vcs_mod      cterm=BOLD  ctermfg=220  ctermbg=240  gui=BOLD  guifg=#FFD700  guibg=#585858
      highlight stl_file_ro      cterm=NONE  ctermfg=196  ctermbg=31   gui=NONE  guifg=#FF0000  guibg=#0087AF
      highlight stl_file         cterm=BOLD  ctermfg=231  ctermbg=31   gui=BOLD  guifg=#FFFFFF  guibg=#0087AF
      highlight stl_file_mod     cterm=BOLD  ctermfg=220  ctermbg=31   gui=BOLD  guifg=#FFD700  guibg=#0087AF
      highlight stl_file_arrow               ctermfg=31   ctermbg=24             guifg=#0087AF  guibg=#005F87
      highlight stl_ft_info                  ctermfg=117  ctermbg=24             guifg=#87D7FF  guibg=#005F87
      highlight stl_per          cterm=NONE  ctermfg=117  ctermbg=31   gui=NONE  guifg=#87D7FF  guibg=#0087AF
      highlight stl_per_arrow    cterm=NONE  ctermfg=117  ctermbg=31   gui=NONE  guifg=#87D7FF  guibg=#0087AF
      highlight stl_line_sym     cterm=NONE  ctermfg=24   ctermbg=117  gui=NONE  guifg=#005F87  guibg=#87D7FF
      highlight stl_line         cterm=BOLD  ctermfg=24   ctermbg=117  gui=BOLD  guifg=#005F87  guibg=#87D7FF
      highlight stl_col          cterm=NONE  ctermfg=22   ctermbg=117  gui=NONE  guifg=#025F00  guibg=#87D7FF
      highlight stl_bufnr        cterm=NONE  ctermfg=24   ctermbg=117  gui=NONE  guifg=#005F87  guibg=#87D7FF
      highlight stl_ws_arrow     cterm=NONE  ctermfg=160  ctermbg=117  gui=NONE  guifg=#D70000  guibg=#87D7FF
      return "  INSERT "

    elseif l:mode ==# "R"
      highlight stl_mode         cterm=BOLD  ctermfg=231  ctermbg=160  gui=BOLD  guifg=#FFFFFF  guibg=#D70000
      highlight stl_mode_arrow               ctermfg=160                         guifg=#D70000
      return "  REPLCE "

    elseif l:mode ==# "v"
      highlight stl_mode         cterm=BOLD  ctermfg=94   ctermbg=214  gui=BOLD  guifg=#875F00  guibg=#FFAF00
      highlight stl_mode_arrow               ctermfg=214                         guifg=#FFAF00
      return "  VISUAL "

    elseif l:mode ==# "V"
      highlight stl_mode         cterm=BOLD  ctermfg=94   ctermbg=214  gui=BOLD  guifg=#875F00  guibg=#FFAF00
      highlight stl_mode_arrow               ctermfg=214                         guifg=#FFAF00
      return "  V·LINE "

    elseif l:mode ==? ""
      highlight stl_mode         cterm=BOLD  ctermfg=94   ctermbg=214  gui=BOLD  guifg=#875F00  guibg=#FFAF00
      highlight stl_mode_arrow               ctermfg=214                         guifg=#FFAF00
      return "  V·BLCK "

    elseif l:mode =~# '\v(s|S|)'
      highlight stl_mode         cterm=BOLD  ctermfg=22   ctermbg=148  gui=BOLD  guifg=#005F00  guibg=#AFD700
      highlight stl_mode_arrow               ctermfg=148                         guifg=#AFD700
      return "  SELECT "

    else
      highlight stl_mode         cterm=BOLD  ctermfg=22   ctermbg=148  gui=BOLD  guifg=#005F00  guibg=#AFD700
      highlight stl_mode_arrow               ctermfg=148                         guifg=#AFD700
      return "  NORMAL "
    endif
  endif
endfunction



function! GitStatus() "          {{{1
  let result = split(system('git status --porcelain '.shellescape(expand('%:t'))." 2>/dev/null|awk '{print $1}'"))
  if len(result) > 0 | return join(result).' ' | else | return '' | endif
endfunction



function! StlTrailingWs() "     {{{1
  return search('\s\+$','nw')
endfunction



function! Stl_col()
  return &bt=="" ? ':'.col('.') : ''
endfunction



"
" = Statusline Segments = "      {{{1
"

set statusline=""
" - Mode -
set statusline+=%#stl_mode#%{&bt==''?StlMode():''}
set statusline+=%#stl_mode_arrow#%{&bt==''?'⮀':''}

" - Paste -
set statusline+=%#stl_paste#%{&bt==''&&&paste?'\ \ PASTE\ ':''}
set statusline+=%#stl_paste_arrow#%{&bt==''&&&paste?'⮀':''}

" - VCS -
"set statusline+=%#StatusLine#
"set statusline+=%{strlen(fugitive#statusline())>0?'\ ⭠\ ':''}
"set statusline+=%{matchstr(fugitive#statusline(),'(\\zs.*\\ze)')}
"set statusline+=%{strlen(fugitive#statusline())>0?'\ \ ⮁\ ':'\ '}
"set statusline+=%{GitStatus()}

" - File info -
" Read-only
set statusline+=%#stl_file_ro#%{&bt==''&&&ro?'\ ':''}
"set statusline+=%#stl_file_ro#%{&ro?'⭤':''}
" Filename
set statusline+=%#stl_file#\ %t
" File modified
set statusline+=%#stl_file_mod#%{&mod?'\ +\ ':'\ '}
set statusline+=%#stl_file_arrow#⮀

" Truncate statusline here
set statusline+=%<

" - Syntastic - warning
"if exists('g:loaded_syntastic_plugin') && g:loaded_syntastic_plugin
"  set statusline+=%#WarningMsg#%{SyntasticStatuslineFlag()}
"endif

" Separation point between left and right aligned items.
set statusline+=%=

" - FileType info-
" File format (unix/dos)
set statusline+=%#stl_ft_info#%{&bt==''&&strlen(&fileformat)>0?&fileformat.'\ ':''}
" File encoding
set statusline+=%{&bt==''&&strlen(&fileencoding)>0?'⮃\ '.&fileencoding.'\ ':''}
" Filetype
set statusline+=%#stl_ft_info#%{&bt==''&&strlen(&filetype)>0?'⮃\ ':''}
set statusline+=%#stl_ft_info#%{strlen(&filetype)>0?&filetype.'\ ':''}
set statusline+=%#stl_ft_arrow#⮂

" Configure percentage
set statusline+=%#stl_per#\ \ %p%%\ 
set statusline+=%#stl_per_arrow#⮂

" Line number
set statusline+=%#stl_line_sym#\ 
"set statusline+=%#stl_line#\ ⭡\ \ %l
set statusline+=%#stl_line#\ %l

" Column number
"set statusline+=%#stl_col#\:%c
set statusline+=%#stl_col#%{Stl_col()}

" Buffer number
set statusline+=%#stl_bufnr#\ %n\ 

" Trailing whitespaces
set statusline+=%#stl_ws_arrow#%{&bt==''&&StlTrailingWs()?'⮂':''}
set statusline+=%#stl_ws#%{&bt==''&&StlTrailingWs()?'\ \ •\ ':''}
