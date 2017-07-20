" Vim Functions file

function! utils#FoldText()                                                                                        " {{{1
  " Description: Dhruv Sagar's foldtext
  let line             = getline(v:foldstart)
  let lines_count      = v:foldend - v:foldstart + 1
  "let folddash        = v:folddashes
  let folddash         = "─"
  let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
  let foldtextend      = lines_count_text . repeat( folddash, 2 )
  let nucolwidth       = &foldcolumn + ( &nu || &rnu ) * &numberwidth
  let foldtextstart    = strpart( line . " ", 0, ( winwidth(0) - nucolwidth - foldtextend ))
  let foldtextlength   = strlen( substitute( foldtextstart . foldtextend, '.', 'x', 'g' )) + nucolwidth
  return foldtextstart . repeat( folddash, winwidth(0) - foldtextlength ) . foldtextend
endfunction


function! utils#CycleNumbering(...)                                                                               " {{{1
  " Description: Cycle through different numbering modes
  " Arguments:
  "   None : Cycle through numbering modes
  "   Any  : Toggle numbering
  if !exists('&relativenumber')
    set number!
    return
  endif
  if a:0
    if ( &nu || &rnu )
      set nonumber norelativenumber
    else
      set number relativenumber
    endif
    return
  endif

  " &nu=1,&rnu=1 -> 1,0 -> 0,1 -> 0,0 -> 1,1
  if !&rnu
    set number!
  endif
  set relativenumber!
endfunction


function! utils#MapKey( rhs, mode )                                                                               " {{{1
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


function! utils#ReTab( tabsize, ... )                                                                             " {{{1
  " Description: Change indentation when tab size is changed.
  "              Primarily used to convert an indentation of eg. 4 to 2 or vice-versa
  " Arguments:
  "   tabsize (int) : The new tabsize to retab to
  "   a:1     (int) : The old tabsize to retab from. When not specified, uses &softtabstop
  "                   When specified, the current tabstop settings aren't changed.
  if &expandtab
    let l:old_ts = &tabstop

    let &tabstop = ( a:0 > 0 ? a:1 : &softtabstop )
    set noexpandtab
    retab!

    let &tabstop = a:tabsize
    set expandtab
    retab!

    if ( a:0 == 0 )
      let &softtabstop = a:tabsize
      let &shiftwidth  = a:tabsize
    endif
    let &tabstop = l:old_ts
  endif
endfunction
command! -nargs=* ReTab call utils#ReTab(<args>)


function! utils#UpdateTags()                                                                                      " {{{1
  " Description: Generate tags ( requires exuberant_ctags )

  if (empty($REPO_PATH))
    echoe '$REPO_PATH is not set'
    return
  endif

  execute "!gentags --create -w $REPO_PATH &"
endfunction

function! utils#LoadCscopeDB()                                                                                    " {{{1
  if !has('cscope')
    return
  endif

  if filereadable("cscope.out")
    let db = "cscope.out"
    " else add the database pointed to by environment variable
  elseif ($CSCOPE_DB != "")
    let db = $CSCOPE_DB
  else
    let db = findfile(".cscope.out", ".;")
  endif

  if (!empty(db))
    silent! execute "cs add " . db
  endif

  cscope reset
endfunction


function! utils#Preserve(command, ...)                                                                            " {{{1
  " Description: Function to execute commands without modifying the original settings like cursor position, search string etc.

  " Find if the command should be executed in visual mode or normal mode
  if (a:0 > 0)
    normal! <Esc>
  endif

  " Save last search, and cursor position.
  let currview = winsaveview()

  if (a:0 > 0)
    normal! gv
  endif

  " Do the business
  let l:keep_cmds = ""
  if exists(":keepjumps")    | let l:keep_cmds .= "keepjumps "    | endif
  if exists(":keeppatterns") | let l:keep_cmds .= "keeppatterns " | endif
  silent! execute l:keep_cmds . a:command

  " Restore previous search history, and cursor position
  call winrestview(currview)
endfunction


function! utils#SynTrace()                                                                                        " {{{1
  " Description: Show syntax highlighting groups for word under cursor
  if !exists("*synstack")
    return
  endif

  let l:synTrace = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  if (len(l:synTrace) == 0)
    echo "No syntax highlighting definition found"
    return
  endif

  let l:hlInfo = utils#GetHighLightInfo(l:synTrace[-1])
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


function! utils#FoldAllBut( foldminlines )                                                                        " {{{1
  " Description: Function to open folds that have less than the specified number of lines
  " We assume that the folds are initially closed
  " If a fold exists and is closed and has lesser number of lines than specified, open it and all nested folds
  " Note: This does not work on nested folds
  folddoclosed
    \ if (( foldclosed(".") >= 0 ) && ( foldclosedend(".") - foldclosed(".") + 1 < a:foldminlines ))
    \   exe 'normal! zO'
    \ endif
endfunction


function! utils#SearchSaveAndRestore(...)                                                                         " {{{1
  " Description: Save and restore search strings
  if a:0 && a:1 ==# "get"
    return s:search_str
  endif

  if ( @/ == "" )
    let @/ = s:search_str
  else
    let s:search_str = @/
  endif
  return @/
endfunction


function! utils#MethodJump( arg )                                                                                 " {{{1
  " Description: Small modification to ]m, [m, ]M, [M to skip over the end of class when using ]m and [m and the start
  "              of the class when using ]M and [M
  " Arguments:
  "   arg = [m / ]m / [M / ]M {

  execute "normal! " . a:arg

  if ( a:arg ==# ']m' || a:arg ==# '[m' )
    if ( getline('.')[col('.')-1] ==# '}' )
      execute "normal! " . a:arg
    endif
  elseif ( a:arg ==# ']M' || a:arg ==# '[M' )
    if ( getline('.')[col('.')-1] ==# '{' )
      execute "normal! " . a:arg
    endif
  endif
endfunction


function! utils#SectionJump(dir, pos)                                                                             " {{{1
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

  if     ( a:dir ==# "next" && a:pos ==# "end" )
    normal! ][
  elseif ( a:dir ==# "prev" && a:pos ==# "end" )
    normal! []

  elseif ( a:dir ==# "next" && a:pos ==# "start" )
    " Jump to the next "}" in the first column and back to its matching brace
    normal! ][%
    " If we're still below the original cursor position, we're done
    if ( line('.') > l:orig_line )
      return
    endif
    " If we've crossed over, then we must've started within a method.
    " Thus, we jump to the 2nd "}" in the first column and back to its matching brace
    normal! ][][%

  elseif ( a:dir ==# "prev" && a:pos ==# "start" )
    " Check if we're at the end of the method. If yes, jump to the start normally
    if ( match(getline('.'), "^}") ==# "}" )
      normal! 0%
    endif
    " Jump to the next "}" in the first column and back to its matching brace
    normal! ][%
    " If we've jumped above the original cursor position, we're done
    if ( line('.') < l:orig_line )
      return
    endif
    " If not, then we must have started between two methods and now we must be at the start of the next method
    " Hence, jump to the previous end of method and then to its matching brace
    normal! []%
  endif
endfunction


function! utils#FillTW(...)                                                                                       " {{{1
  " Description: Insert spaces to make the current line as wide as specified by textwidth or the supplied width
  " Arguments:  If argument is supplied use the provided value instead of textwidth to fill
  let l:filler    = nr2char(getchar())
  let l:textwidth = ( a:0 > 0 ? a:1 : &textwidth )
  let l:line      = getline('.')
  let l:padding   = repeat( l:filler, l:textwidth - len(l:line) )
  execute "normal! i" . l:padding
  call repeat#set(":FTW " . l:textwidth . "\<CR>" . l:filler)
endfunction
command! -nargs=? FTW call utils#FillTW(<args>)


function! utils#EatChar( pat )                                                                                    " {{{1
  let c = nr2char( getchar(0) )
  return (c =~ a:pat) ? '' : c
endfunc


function! utils#CmdIsk( mode )                                                                                    " {{{1
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


function! utils#MagicSave(...)                                                                                    " {{{1
  " Description: If directory does not exist, create while saving the file
  if a:0
    let directory = fnamemodify(a:1, ':p:h')
    let file = a:1
  else
    let directory = expand('%:p:h')
    let file = expand('%')
  endif
  if !isdirectory(directory)
    call mkdir(directory, 'p')
  endif
  execute 'write' file
endfunction
command! -nargs=? WW call utils#MagicSave(<q-args>)


function! utils#CursorBlind()                                                                                     " {{{1
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


function! utils#BuffersList()                                                                                     " {{{1
  " Description: Returns a list of open buffers
  let res = []
  for b in range(1, bufnr('$'))
    if buflisted(b)
      call add(res, bufname(b))
    endif
  endfor
  return res
endfunction


function! utils#FindAndList( scope, mode, ... )                                                                   " {{{1
  " Description: Find all the lines that contain the search term and display them in the location list
  " Arguments:
  "   scope (str) "local"    : Find only with the current buffer and display results in a location list
  "               "global"   : Find across all windows and display results in a quickfix list
  "   mode  (str) "normal"   : The default mode. Use the default value if provided one
  "               "visual"   : Use the value stored in @* to search
  "               "prev"     : Use the previously searched term
  "   default (a:1, str)     : Default value to be specified at the "Find:" prompt. Meaningful only in "normal" mode
  let prompt = ( a:0 > 0 ? a:1 : "" )
  if a:mode ==? "visual"
    let prompt = escape(@*, '$*[]/')
  elseif a:mode ==? "prev"
    let prompt = utils#SearchSaveAndRestore('get')
  endif
  let term = input( substitute(a:scope, '.*', '\L\u\0', '') . ': /', prompt)

  let v:errmsg = ""
  " Return if search term is empty
  if term == ""
    "let term = expand('<cword>')
    return
  endif
  if ( v:errmsg != "" ) | return | endif

  if ( a:scope ==? "local" )
    execute "noautocmd lvimgrep! /" . term . "/ " . fnameescape(expand('%:p'))
    lopen 15
    syntax match qfFileName /^[^|]*|[^|]*| / transparent conceal
    setlocal nowrap
  elseif ( a:scope ==? "global" )
    execute "noautocmd vimgrep! /" . term . "/ " . join(utils#BuffersList())
    copen 15
    setlocal nowrap
  endif
endfunction


function! utils#GuiTabLabel()                                                                                     " {{{1
  " Description: Set up tab labels with tab number, buffer name, number of windows
  if (exists('t:guitablabel'))
    return t:guitablabel
  endif

  let label = ''
  let bufnrlist = tabpagebuflist(v:lnum)
  " Add '+' if one of the buffers in the tab page is modified
  for bufnr in bufnrlist
    if getbufvar(bufnr, "&modified")
      let label = '+'
      break
    endif
  endfor
  " Append the tab number
  let label .= v:lnum.': '
  " Append the buffer name
  let name = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
  if name == ''
    " give a name to no-name documents
    if &buftype=='quickfix'
      let name = '[Quickfix List]'
    else
      let name = '[No Name]'
    endif
  else
    " get only the file name
    let name = fnamemodify(name,":t")
  endif
  let label .= name
  " Append the number of windows in the tab page
  let wincount = tabpagewinnr(v:lnum, '$')
  return label . '  [' . wincount . ']'
endfunction


function! utils#GuiTabToolTip()                                                                                   " {{{1
  " Description: Set up tab tooltips to show every buffer name
  let tip = ''
  let bufnrlist = tabpagebuflist(v:lnum)
  for bufnr in bufnrlist
    " separate buffer entries
    if tip!=''
      let tip .= " \n "
    endif
    " Add name of buffer
    let name=bufname(bufnr)
    if name == ''
      " give a name to no name documents
      if getbufvar(bufnr,'&buftype')=='quickfix'
        let name = '[Quickfix List]'
      else
        let name = '[No Name]'
      endif
    else
      " get only the file name
      let name = fnamemodify(name,":t")
    endif
    let tip.=name
    " add modified/modifiable flags
    if getbufvar(bufnr, "&modified")
      let tip .= ' [+]'
    endif
    if getbufvar(bufnr, "&modifiable")==0
      let tip .= ' [-]'
    endif
  endfor
  return tip
endfunction

function! utils#GetHighLightInfo( hl_group )                                                                      " {{{1
  " Description: Copy/modify highlight groups
  let l:hlTrace = [a:hl_group]
  redir => l:hl_info_str
  execute 'silent highlight ' . a:hl_group
  redir END

  " Find the root highlighting scheme
  let l:hl_match = matchlist( l:hl_info_str, 'links to \(\w\+\)' )
  while len( l:hl_match ) > 0
    call add(l:hlTrace, l:hl_match[1])
    redir => l:hl_info_str
    execute 'silent highlight ' . l:hl_match[1]
    redir END
    let l:hl_match = matchlist( l:hl_info_str, 'links to \(\w\+\)' )
  endwhile
  "echo l:hlTrace

  let l:hl_info = {}
  for i in filter( split( l:hl_info_str, ' \+' ), 'v:val =~ "="' )
    let l:hl_info[split(i,'=')[0]] = split(i,'=')[1]
  endfor
  let l:hl_info.trace = l:hlTrace

  "echo   l:hl_info
  return l:hl_info
endfunction


function! utils#SetHighLightInfo( hl_group, hl_info )                                                             " {{{1
  let l:hl_cmd = 'highlight ' . a:hl_group . ' '
  for l:attr in keys(a:hl_info)
    if (l:attr ==? 'trace')
      continue
    endif
    let l:hl_cmd .= l:attr . '=' . a:hl_info[l:attr] . ' '
  endfor

  execute l:hl_cmd
endfunction


function! utils#WindowSwap()                                                                                      " {{{1
  " Description: Swap windows. Works similar to tommcdo's vim-exchange plugin but with windows
  "              When only 2 windows are open in the current tab, execute '<C-W>x'
  "              Calling this the first time selects the 1st window of the pair to swap.
  "              Calling it again swaps the buffers of the two windows

  if ( winnr('$') == 2 )
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


function! utils#CscopeMap(view, exec, ...)                                                                        " {{{1
  " Description: One function to execute cscope commands instead of a ton of mappings
  " Arguments:
  "   view (char) : How to display results (l: Location list, s: Horizontal split, v: Vertical split)
  "   exec (bool) : Whether to (0) use <cword> or <cfile> appropriately or
  "                            (1) obtain search term from user
  "   a:1         : Text to search for. If nothing is specified when exec=0, user has to input on the command line
  "
  " Find type is determined by a getchar() call. Both bare-chars and control-chars (s / <C-S>) etc. are supported
  " If v/<C-V> or s/<C-S> is entered, the results will be displayed in a vertical/horizontal split and
  " getchar() will be invoked again to deterine the find type.
  "
  "   'y'   symbol:       find all references to the token under cursor
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

  let l:type = getchar()
  let l:type = nr2char( l:type <= 26 ? l:type + 96 : l:type )

  let l:regetchar = 1
  if l:type ==# 'v'
    let cmd = 'vert s'
  elseif l:type ==# 's'
    let cmd = 's'
  else
    let l:regetchar = 0
  endif

  if l:regetchar
    let l:type = getchar()
    let l:type = nr2char( l:type <= 26 ? l:type + 96 : l:type )
  else
    if (a:view ==# 'v')
      let cmd = 'vert s'
    else
      let cmd = a:view
    endif
  endif

  let l:type = (l:type ==# 'y' ? 's' : l:type )
  let cmd .= 'cscope find ' . l:type

  if a:exec
    call feedkeys( ':' . cmd . ' ')
    return
  endif

  if (a:0 > 0)
    let l:str = a:1
  elseif (l:type == 'f')
    let l:str = expand('<cfile>')
  elseif (l:type == 'i')
    let l:str = '^' . expand('<cfile>') . '$'
  else
    let l:str = expand('<cword>')
  endif

  let cmd .= ' ' . l:str
  "echom '>>' . cmd . '<<'
  execute cmd
endfunction


function! utils#CombineSelection(line1, line2, cp)                                                                " {{{1
  " Description: Modify selected text using combining diacritics
  execute 'let char = "\u' . a:cp . '"'
  execute a:line1 . ',' . a:line2 . 's/\%V[^[:cntrl:]]/&' . char . '/ge'
endfunction
command! -range -nargs=0 Overline        call utils#CombineSelection(<line1>, <line2>, '0305')
command! -range -nargs=0 Underline       call utils#CombineSelection(<line1>, <line2>, '0332')
command! -range -nargs=0 DoubleUnderline call utils#CombineSelection(<line1>, <line2>, '0333')
command! -range -nargs=0 Strikethrough   call utils#CombineSelection(<line1>, <line2>, '0336')


function! utils#SetDiffFileType()                                                                                 " {{{1
  let l:filetype=''
  windo if (l:filetype == '')|let l:filetype=&filetype|endif
  windo let &filetype=l:filetype
endfunction


function! utils#GetWindowColumnsWidth()                                                                           " {{{1
  " Get the width of the decorative columns of the CURRENT window

  let l:width = 0

  " Width of number column
  let l:lnum_max = 0
  if &l:number
    let l:lnum_max = line('$')
  elseif (  exists('+relativenumber')
       \ && &l:relativenumber
       \ )
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


function! utils#Journal(cmd, ...)                                                                                 " {{{1
  " Description: Execute cmd and return the output as a list of lines.
  "              If an additional argument is provided, use it to filter the output.
  " Arguments:   cmd - The command to execute
  "              a:1 - The filter to apply on the output of the command
  "              a:2 - Whether to pretty-print (no a:2) or just return the output (provide a:2)
  redir => l:out
  silent! execute a:cmd
  redir END
  let l:out_arr = split(l:out, '\n')
  if a:0
    execute "call filter(l:out_arr, 'v:val " . a:1 "')"
  endif
  if (a:0 > 1)
    return l:out_arr
  else
    for l:i in l:out_arr
      echo l:i
    endfor
  endif
endfunction


function! utils#WindowToggleZoom ()                                                                               " {{{1
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
" }}}1



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VERSION CONTROL                                                                                                 " {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! utils#VcsSetupMergeLayout()                                                                             " {{{2
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Temporary functions only
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! utils#_RemoveAllErrInBut_(num)                                                                          " {{{1
  " Delete everything but the entry we're interested in just the ErrIn field
  silent! execute '%g/L3ErrPkt/ .s/\v(ErrIn\w*)@<=\=\{[^}]{-}(\[' . a:num . '\]\s*\=\s*[^,]+)[^}]{-}\}/\2/g'
endfunction
"nnoremap K :<C-U>call utils#TestFunc(v:count, v:count1)<CR>


function! utils#Bisect()                                                                                          " {{{1
  let l:pos=getpos('.')
  norm %
  let l:pos[1]=(l:pos[1]+line('.'))/2
  let l:pos[2]=(l:pos[2]+col('.'))/2
  call setpos('.', l:pos)
endfunction
