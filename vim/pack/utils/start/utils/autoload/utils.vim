" Vim Functions file

function! utils#Bufdo(command)                                                                                     "{{{1
  " Description: Like bufdo but restore the current buffer
  let l:curr=bufnr("%")
  execute 'bufdo ' . a:command
  execute 'buffer ' . l:curr
endfunction
command! -nargs=+ -complete=command Bufdo call utils#Bufdo(<q-args>)

function! utils#Tabdo(command)                                                                                     "{{{1
  " Description: Like tabdo but restore the current buffer
  let l:curr=tabpagenr("%")
  execute 'tabdo ' . a:command
  execute 'tabnext ' . l:curr
endfunction
command! -nargs=+ -complete=command Tabdo call utils#Tabdo(<q-args>)

function! utils#Windo(command)                                                                                     "{{{1
  " Description: Like windo but restore the current winfer
  let l:curr=winnr("%")
  execute 'windo ' . a:command
  execute l:curr . 'wincmd w'
endfunction
command! -nargs=+ -complete=command Windo call utils#Windo(<q-args>)

function! utils#BuffersList()                                                                                      "{{{1
  " Description: Returns a list of open buffers
  let res = []
  for b in range(1, bufnr('$'))
    if buflisted(b)
      call add(res, bufname(b))
    endif
  endfor
  return res
endfunction


function! utils#Preserve(expr)                                                                                     "{{{1
  " Description: Function to execute commands without modifying the original settings like cursor position, search string etc.
  " Arguments:   The expression to execute.
  "              TODO: Any settings that must be saved and restored can be supplied in a list as the optional argument
  "              SYNTAX of Optional Args: [ (argname1, argval1), ... ]

  " Save window and cursor position.
  let l:win_id = win_getid()
  let l:currview = winsaveview()

  " Do the business
  let l:keep_cmds = ""
  if exists(":keepjumps")    | let l:keep_cmds .= "keepjumps "    | endif
  if exists(":keeppatterns") | let l:keep_cmds .= "keeppatterns " | endif
  silent! execute l:keep_cmds . a:expr

  " Restore previous search history, and cursor position
  call winrestview(l:currview)
  call win_gotoid(l:win_id)
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


function! utils#EatChar(pat)                                                                                       "{{{1
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc


function! utils#CursorBlind()                                                                                      "{{{1
  " Description: Flash the cursorcolumn and cursorline till the cursor is moved
  if &cuc || &cul
    set nocursorline nocursorcolumn
    augroup CursorBlind
      au!
    augroup END
  else
    set cursorcolumn cursorline
    augroup CursorBlind
      au!
      au CursorHold,CursorMoved * call utils#CursorBlind()
    augroup END
  endif
endfunction


function! utils#FindAndList(scope, mode, ...)                                                                      "{{{1
  " Description: Find all the lines that contain the search term and display them in the location list
  " Arguments:
  "   scope (str) "local"    : Find only with the current buffer and display results in a location list
  "               "global"   : Find across all windows and display results in a quickfix list
  "   mode  (str) "normal"   : The default mode. Use the default value if provided one
  "               "visual"   : Use the value stored in @* to search
  "               "prev"     : Use the previously searched term
  "   default (a:1, str)     : Default value to be specified at the "Find:" prompt. Meaningful only in "normal" mode
  let prompt = (a:0 > 0 ? a:1 : '\v')
  if a:mode ==? "visual"
    let prompt = escape(@*, '$*[]/')
  elseif a:mode ==? "prev"
    let prompt = utils#SearchSaveAndRestore('get')
  endif
  let term = input(substitute(a:scope, '.*', '\L\u\0', '') . ': /', prompt)

  let v:errmsg = ""
  " Return if search term is empty
  if term == ""
    "let term = expand('<cword>')
    return
  endif
  if (v:errmsg != "") | return | endif

  if (a:scope ==? "local")
    execute "noautocmd lvimgrep! /" . term . "/ " . fnameescape(expand('%:p'))
    lopen 15
    syntax match qfFileName /^[^|]*|[^|]*| / transparent conceal
    setlocal nowrap
  elseif (a:scope ==? "global")
    execute "noautocmd vimgrep! /" . term . "/ " . join(utils#BuffersList())
    copen 15
    setlocal nowrap
  endif
endfunction


function! utils#WindowSwap()                                                                                       "{{{1
  " Description: Swap windows. Works similar to tommcdo's vim-exchange plugin but with windows
  "              When only 2 windows are open in the current tab, execute '<C-W>x'
  "              Calling this the first time selects the 1st window of the pair to swap.
  "              Calling it again swaps the buffers of the two windows

  if (winnr('$') == 2)
    silent execute 'wincmd x'
    return
  endif

  " Select first window
  if !exists('g:WindowSwap_Win1')
    let g:WindowSwap_Win1 = winnr()
    return
  endif

  " Save attributes of the 2nd window
  let l:Win2 = winnr()
  let l:Buf2 = bufnr('%')

  " Switch to Win1 and change to Buf2
  execute g:WindowSwap_Win1 . 'wincmd w'
  let l:Buf1 = bufnr('%')
  " Hide and open so that we don't keep history
  execute 'hide buffer' . l:Buf2

  " Switch back to Win2 and change to Buf1
  execute l:Win2 . 'wincmd w'
  " Hide and open so that we don't keep history
  execute 'hide buf' l:Buf1

  " Clean-up
  unlet g:WindowSwap_Win1
endfunction


function! utils#SetFileTypesInDiff()                                                                               "{{{1
  let g:filetype=''
  Bufdo if (g:filetype == '' && &filetype != 'conf')|let g:filetype=&filetype|endif
  " echom "DEBUG: Found filetype=" . g:filetype
  Bufdo let &filetype=g:filetype
endfunction


function! utils#GetWindowColumnsWidth()                                                                            "{{{1
  " Get the width of the decorative columns of the CURRENT window

  let l:width = 0

  " Width of number column
  let l:lnum_max = 0
  if &l:number
    let l:lnum_max = line('$')
  elseif (exists('+relativenumber')
       \ && &l:relativenumber
       \)
    let l:lnum_max = winheight(0)/2
  endif
  if (l:lnum_max > 0)
    let l:width += max([strlen(l:lnum_max) + 1, &l:numberwidth])
  endif

  " Width of fold column
  if has('folding')
    let l:width += &l:foldcolumn
  endif

  " Width of sign column
  if has('signs')
    redir => l:signsOutput
      silent execute 'sign place buffer=' . bufnr('%')
    redir END

    " The ':sign place' output contains two header lines.
    " The sign column is fixed at two columns.
    if len(split(l:signsOutput, "\n")) > 2
      let l:width += 2
    endif
  endif

  return l:width
endfunction


function! utils#Journal(cmd, ...)                                                                                  "{{{1
  " Description: Execute cmd and return the output as a list of lines.
  "              If an additional argument is provided, use it to filter the output.
  " Arguments:   cmd : The command to execute
  "              a:1 : The filter to apply on the output of the command
  "              a:2 : 0 = Pretty-print the array (default, if not specified)
  "                    1 = Return raw array
  redir => l:out|silent! execute a:cmd|redir END
  let l:out_arr = split(l:out, '\n')
  if a:0
    execute "call filter(l:out_arr, '" . a:1 . "')"
  endif
  if (a:0 > 1)
    return l:out_arr
  else
    for l:i in l:out_arr
      echo l:i
    endfor
  endif
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


function! utils#Bisect()                                                                                           "{{{1
  let l:pos=getpos('.')
  norm %
  let l:pos[1]=(l:pos[1]+line('.'))/2
  let l:pos[2]=(l:pos[2]+col('.'))/2
  call setpos('.', l:pos)
endfunction


function! utils#BaseConverter(n, obase)                                                                            "{{{1
  " Description: Convert the word under the cursor to the specified base
  " Arguments:
  "   n     (string) : The number to convert
  "   obase (int)    : The output base to convert it to
  " echo "DEBUG: n=" . a:n . ", obase=" . a:obase

  let l:obase_str = get({ 2:'bin', 8:'oct', 10:'dec', 16:'hex' }, a:obase, "")
  if (l:obase_str == "")
    echo "Unable to represent " . a:n . " in base " . a:obase
    return
  endif

  let l:obase_fmt = get({ 2:'%b',  8:'%o',  10:'%d',  16:'%x'  }, a:obase)

  return printf(l:obase_str . "(%s) = " . l:obase_fmt, a:n, a:n)
endfunction
" }}}1
