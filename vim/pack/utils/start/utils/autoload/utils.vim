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


function! utils#MapKey(rhs, mode)                                                                                  "{{{1
  " Description: Get LHS of a mapping. Inverse of maparg().
  " Note that hasmapto() returns a binary result while MapKey() returns the value of the LHS.
  " Pass in a key sequence and the first letter of a vim mode.
  " Returns key mapping mapped to it in that mode, else '' if none.
  " Eg:
  "   :nnoremap <Tab> :bn<CR>
  "   :call Mapkey(':bn<CR>', 'n')
  " returns <Tab>
  " TODO:
  " * Modify the function to be capable of returning multiple values.
  "   Eg. if multiple lhs mappings perform the same action then calling MapKey() should return all of them
  execute 'redir => l:mappings | silent! ' . a:mode . 'map | redir END'

  " Convert all text between angle-brackets to lowercase. We require this to recognize all case-variants of <c-A> and
  " <C-a> as the same thing.
  " Note that Alt mappings are case-sensitive. However, this is not an issue as <A-x> is replaced with its approriate
  " keycode for eg. <A-a> becomes á
  let l:rhs = substitute(a:rhs, '<[^>]\+>', "\\L\\0", 'g')

  for l:map in split(l:mappings, '\n')
    " Get rhs for each mapping
    let l:lhs = split(l:map, '\s\+')[1]
    let l:lhs_map = maparg(l:lhs, a:mode)

    if substitute(l:lhs_map, '<[^>]\+>', "\\L\\0", 'g') ==# l:rhs
      return l:lhs
    endif
  endfor
  return ''
endfunction


" FIXME: Check that this works
function! utils#Retab(tabsize, ...)                                                                                "{{{1
  " Description: Change indentation when tab size is changed.
  "              Primarily used to convert an indentation of eg. 4 to 2 or vice-versa
  " Arguments:
  "   tabsize (int) : The new tabsize to retab to
  "   a:1     (int) : The old tabsize to retab from. When not specified, uses &softtabstop
  "                   When specified, the current tabstop settings aren't changed.
  if &expandtab
    let l:old_ts = &tabstop

    let &tabstop = (a:0 > 0 ? a:1 : &softtabstop)
    set noexpandtab
    retab!

    let &tabstop = a:tabsize
    set expandtab
    retab!

    if (a:0 == 0)
      let &softtabstop = a:tabsize
      let &shiftwidth  = a:tabsize
    endif
    let &tabstop = l:old_ts
  endif
endfunction
command! -nargs=* Retab call utils#Retab(<args>)


function! utils#Preserve(expr, ...)                                                                                "{{{1
  " Description: Function to execute commands without modifying the original settings like cursor position, search string etc.
  " Arguments:   The expression to execute.
  "              TODO: Any settings that must be saved and restored can be supplied in a list as the optional argument
  "              SYNTAX of Optional Args: [ (argname1, argval1), ... ]

  " Save last search, and cursor position.
  let currview = winsaveview()

  " Do the business
  let l:keep_cmds = ""
  if exists(":keepjumps")    | let l:keep_cmds .= "keepjumps "    | endif
  if exists(":keeppatterns") | let l:keep_cmds .= "keeppatterns " | endif
  silent! execute l:keep_cmds . a:expr

  " Restore previous search history, and cursor position
  call winrestview(currview)
endfunction


function! utils#SynTrace()                                                                                         "{{{1
  " Description: Show syntax highlighting groups for word under cursor
  if !exists("*synstack")
    return
  endif

  let l:synTrace = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  if (len(l:synTrace) == 0)
    echo "No syntax highlighting definition found"
    return
  endif

  let l:hlInfo = utils#GetHighlightInfo(l:synTrace[-1])
  "echo l:hlInfo.trace

  let l:out = "{"
  for i in l:hlInfo.trace
    let l:out .= i
    let l:out .= (i == l:hlInfo.trace[-1] ? "}: {" : " -> ")
  endfor

  for i in keys(l:hlInfo)
    if (i ==? 'trace')
      continue
    endif
    let l:out .= "'" . i . "': '" . "'" . l:hlInfo[i] . "'"
    let l:out .= (i ==  keys(l:hlInfo)[-1] ? "}" : ", ")
  endfor
  "echo l:out
  return l:out
endfunction
" FIXME: Get the command working
command! -nargs=0 SynTrace call utils#SynTrace()


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


function! utils#EatChar(pat)                                                                                       "{{{1
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc


function! utils#CmdIsk(mode)                                                                                       "{{{1
  " Description: Modify the value of iskeyword by adding a dot or restoring to original value depending upon input arg
  "              Used mainly to make traversing up the directory tree easier in cmd-mode
  " Arguments:
  "   mode (int) 1 - Save the current value of iskeyword and append a '.' to it
  "              0 - Restore the value of iskeyword
  if a:mode
    let s:isk=&isk
    set iskeyword+=.
  else
    let &isk=s:isk
  endif
  return ""
endfunction


" FIXME: Use ! to save using sudo and replace :WW with :W
function! utils#MagicSave(sudo, ...)                                                                               "{{{1
  " Description: If directory does not exist, create while saving the file

  " echom "DEBUG: Args#=" . a:0
  " echom "DEBUG: Args1=" . a:1
  " echom "DEBUG: Args2=" . a:2

  for l:file in a:000
    let directory = fnamemodify(l:file, ':p:h')

    if !isdirectory(directory)
      call mkdir(directory, 'p')
    endif

    if a:sudo
      execute 'write !sudo tee ' . l:file . ' > /dev/null'
    else
      execute 'write ' . l:file
    endif
  endfor
endfunction
command! -bang -nargs=+ W call utils#MagicSave(<bang>0, <q-args>)


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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VERSION CONTROL                                                                                                  "{{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! utils#VcsSetupMergeLayout()                                                                              "{{{2
  " Description: Setup layout for merges
  "              Tab 1: Main window with all 4 panes (Clockwise from top-left)
  "                - Base (Original), Remote (Theirs), Local (Yours) and Merge
  "              Tab 2: Diff of Base v/s Remote
  "              Tab 3: Diff of Base v/s Local
  "              Tab 4: Diff of Remote v/s Local
  "              Tab 5: Diff of Remote v/s Merge
  "              Tab 6: Diff of Local  v/s Merge
  "
  "              Git     v/s  Perforce
  "              Base     |   Original
  "              Remote   |   Theirs
  "              Local    |   Yours
  "              Merge    |   Merge

  " Arguments: All arguments are optional and the only thing they're used for is to name the tabs
  let l:base_str   = get(a:000, 0, 'Base')
  let l:remote_str = get(a:000, 1, 'Remote')
  let l:local_str  = get(a:000, 2, 'Local')
  let l:merge_str  = get(a:000, 3, 'Merge')

  let l:base   = argv(0)
  let l:remote = argv(1)
  let l:local  = argv(2)
  let l:merge  = argv(3)

  " Init
  tabonly|wincmd o

  " Main merging tab
  exec "b " . l:merge
  wincmd s
  wincmd t
  exec "b " . l:base
  wincmd v
  exec "b " . l:remote
  wincmd v
  exec "b " . l:local
  set readonly
  windo diffthis
  let t:guitablabel='Main'

  " Diff - Base vs Remote
  exec "tabe " . l:base
  wincmd v
  exec "b " . l:remote
  windo diffthis
  let t:guitablabel = l:base_str . ' v/s ' . l:remote_str

  " Diff - Base vs Local
  exec "tabe " . l:base
  wincmd v
  exec "b " . l:local
  set readonly
  windo diffthis
  let t:guitablabel = l:base_str . ' v/s ' . l:local_str

  " Diff - Remote vs Local
  exec "tabe " . l:remote
  wincmd v
  exec "b " . l:local
  set readonly
  windo diffthis
  let t:guitablabel = l:remote_str . ' v/s ' . l:local_str

  " Diff - Remote vs Merge
  exec "tabe " . l:remote
  wincmd v
  exec "b " . l:merge
  windo diffthis
  let t:guitablabel = l:remote_str . ' v/s Merge'

  " Diff - Local vs Merge
  exec "tabe " . l:local
  wincmd v
  exec "b " . l:merge
  set readonly
  windo diffthis
  let t:guitablabel = l:local_str . ' v/s Merge'

  set columns=400
  tabdo wincmd =
  tabfirst
endfunction
" }}}2
