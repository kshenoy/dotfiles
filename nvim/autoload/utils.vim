" Vim Functions file
function! utils#MethodJump(arg)                                                                                    "{{{1
  " Description: Small modification to ]m, [m, ]M, [M to skip over the end of class when using ]m and [m and the start
  "              of the class when using ]M and [M
  " Arguments:
  "   arg = [m / ]m / [M / ]M {

  execute "normal! " . a:arg

  if (a:arg ==# ']m' || a:arg ==# '[m')
    if (getline('.')[col('.')-1] ==# '}')
      execute "normal! " . a:arg
    endif
  elseif (a:arg ==# ']M' || a:arg ==# '[M')
    if (getline('.')[col('.')-1] ==# '{')
      execute "normal! " . a:arg
    endif
  endif
endfunction


function! utils#SectionJump(dir, pos)                                                                              "{{{1
  " Description: Jump to next/previous start/end of method
  "              Assumes that the end of the function can be identified by a "}" in the first column
  " Arguments:
  "   dir = 'next'  - Jump to next instance
  "         'prev'  - Jump to previous instance
  "   pos = 'start' - Jump to start of method
  "         'end'   - Jump to end of method

  " Save original cursor position
  let l:orig_line = line('.')
  let l:orig_col  = col('.')

  if     (a:dir ==# "next" && a:pos ==# "end")
    normal! ][
  elseif (a:dir ==# "prev" && a:pos ==# "end")
    normal! []

  elseif (a:dir ==# "next" && a:pos ==# "start")
    " Jump to the next "}" in the first column and back to its matching brace
    normal! ][%
    " If we're still below the original cursor position, we're done
    if (line('.') > l:orig_line)
      return
    endif
    " If we've crossed over, then we must've started within a method.
    " Thus, we jump to the 2nd "}" in the first column and back to its matching brace
    normal! ][][%

  elseif (a:dir ==# "prev" && a:pos ==# "start")
    " Check if we're at the end of the method. If yes, jump to the start normally
    if (match(getline('.'), "^}") ==# "}")
      normal! 0%
    endif
    " Jump to the next "}" in the first column and back to its matching brace
    normal! ][%
    " If we've jumped above the original cursor position, we're done
    if (line('.') < l:orig_line)
      return
    endif
    " If not, then we must have started between two methods and now we must be at the start of the next method
    " Hence, jump to the previous end of method and then to its matching brace
    normal! []%
  endif
endfunction


function! utils#FillTW(...)                                                                                        "{{{1
  " Description: Insert spaces to make the current line as wide as specified by textwidth or the supplied width
  " Arguments:  If argument is supplied use the provided value instead of textwidth to fill
  let l:filler    = nr2char(getchar())
  let l:textwidth = (a:0 > 0 ? a:1 : &textwidth)
  let l:line      = getline('.')
  let l:padding   = repeat(l:filler, l:textwidth - len(l:line))
  execute "normal! i" . l:padding
  call repeat#set(":FTW " . l:textwidth . "\<CR>" . l:filler)
endfunction


function! utils#SetFileTypesInDiff()                                                                               "{{{1
  let g:filetype=''
  Bufdo if (g:filetype == '' && &filetype != 'conf')|let g:filetype=&filetype|endif
  " echom "DEBUG: Found filetype=" . g:filetype
  Bufdo let &filetype=g:filetype
endfunction


function! utils#WindowToggleZoom ()                                                                                "{{{1
  " Description: Zoom/unzoom similar to TMUX

  if (winnr('$') == 1)
    return
  endif

  let l:restore_cmd = winrestcmd()
  wincmd |
  wincmd _

  " If zomming has no effect, we need to undo it.
  if (l:restore_cmd ==# winrestcmd())
    exe t:zoom_restore
  else
    let t:zoom_restore = l:restore_cmd
  endif
endfunction
