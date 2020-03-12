""" All code navigation and completion related settings that use ctags/cscope

function! intellisensish_ctags#CscopeMap(auto)                                                                 "{{{1
  " Description: One function to execute cscope commands instead of a ton of mappings
  " Arguments:
  "   auto (bool) : Whether to (0) use <cword> or <cfile> appropriately or
  "                            (1) obtain search term from user
  "
  " Results will always be displayed in the location list
  "
  " Find type is determined by a getchar() call.
  " If <C-V> or <C-S> is entered, the results will be displayed in a vertical/horizontal split and
  " getchar() will be invoked again to deterine the find type.
  "
  "   's'   symbol:       find all references to the token under cursor
  "   'g'   global:       find global definition(s) of the token under cursor
  "   'c'   calls:        find all calls to the function name under cursor
  "   't'   text:         find all instances of the text under cursor
  "   'e'   egrep:        egrep search for the word under cursor
  "   'f'   file:         open the filename under cursor
  "   'i'   includes:     find files that include the filename under cursor
  "   'd'   called:       find functions that the function under cursor calls

  if !has('cscope')
    return
  endif

  let l:cmd_type = getchar()
  let l:cmd = ""
  if (l:cmd_type <= 26)
    " A control character was entered. We need to determine how to display the result
    let l:disp_type = nr2char(l:cmd_type + 96)

    if l:disp_type ==# 'v'
      let l:cmd = "vert s"
    elseif l:disp_type ==# 's'
      let l:cmd = "s"
    else
      echoe "Illegal display parameter. Only <C-S>:horizontal split and <C-V>:vertical split are supported"
    endif

    let l:cmd_type = getchar()
  endif

  let l:cmd_type = nr2char(l:cmd_type)
  if (index(['s', 'g', 'c', 't', 'e', 'f', 'i', 'd'], l:cmd_type) == -1)
    echoe "Illegal command type '" . l:cmd_type . "'. Run ':h cscope-find' for a list of supported commands"
  endif

  let l:cmd .= 'cscope find ' . l:cmd_type

  if a:auto
    if (l:cmd_type == 'f')
      let l:str = expand('<cfile>')
    elseif (l:cmd_type == 'i')
      let l:str = '^' . expand('<cfile>') . '$'
    else
      let l:str = expand('<cword>')
    endif

    let l:cmd .= ' ' . l:str
    "echom '>>' . l:cmd . '<<'
    execute l:cmd
  else
    call feedkeys(':' . l:cmd . ' ')
  endif
endfunction


function! intellisensish_ctags#UpdateTags(silent)                                                              "{{{1
  " Description: Generate tags (requires exuberant_ctags)

  if (empty($REPO_PATH))
    return
  endif

  let l:cmd = "gentags -w $REPO_PATH"
  if v:version >= 800
    if exists('s:job') && job_status(s:job) == "run"
      if !a:silent
        echom "Another process (" . split(s:job, '\s\+')[1] . ") is already generating tags. Skipping"
      endif
      return
    endif
    if a:silent
      let s:job=job_start(l:cmd)
    else
      let s:job=job_start(l:cmd, {'close_cb': 'intellisensish_ctags#UpdateTagsDone'})
    endif
  else
    execute "!" . l:cmd
  endif
endfunction


function! intellisensish_ctags#UpdateTagsDone(...)
  " Description: Dumb function that uses echom to notify that job is done
  silent cs reset
  echom "Tags successfully generated"
endfunction
