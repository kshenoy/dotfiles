"=======================================================================================================================
function! utils#SetFileTypesInDiff()                                                                               "{{{1
  let g:filetype=''
  Bufdo if (g:filetype == '' && &filetype != 'conf')|let g:filetype=&filetype|endif
  " echom "DEBUG: Found filetype=" . g:filetype
  Bufdo let &filetype=g:filetype
endfunction


"=======================================================================================================================
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
