function! perforce#Checkout(...)                                                                                   "{{{1
  " Description: Confirm with the user, then checkout a file from perforce.
  " Arguments: -force   - Prompt user to confirm if they want to check the file out
  "            filename - If not specified, checkout the current file

  " Check that we're not in a regression work-area (not fool-proof)
  if (  ($STEM == "")
   \ || ($STEM =~ 'regr_build\|regrplatform')
   \ )
    setlocal nomodifiable
    return
  endif

  let l:prompt=0
  let l:args = copy(a:000)
  for i in range(len(l:args))
    if (l:args[i] == "-force")
      let l:prompt=1
      remove(l:args, i)
      break
    endif
  endfor

  if (len(l:args) == 0)
    call add(l:args, expand('%:p'))
  endif

  " Filter out if we get any errors while running p4 files eg. opening a file from p4v
  for l:filename in l:args
    let l:p4path = substitute(system("p4 files " . l:filename), '#.*$', '', '')

    if (  l:p4path !~ '^//depot')
     \ || (  l:prompt
       \  && (confirm("Checkout from Perforce?", "&Yes\n&No", 1) == 0)
       \  )
      setlocal nomodifiable
      return
    endif

    call system("p4 edit " . l:p4path . " > /dev/null")
    if (v:shell_error == 0)
      setlocal noreadonly
      return
    endif
  endfor
endfunction


function! perforce#MergeInit()                                                                                     "{{{1
  " Description: Sets up merge layout and creates keybindings
  call s:SetupMergeLayout('Original', 'Theirs', 'Yours', 'Merge')
  call s:CreateMergeMaps()
endfunction
" }}}1


let s:conflict_ORIGINAL='^>>>> ORIGINAL'
let s:conflict_THEIRS='^==== THEIRS'
let s:conflict_YOURS='^==== YOURS'
let s:conflict_END='^<<<<'
let s:conflict_ANY=s:conflict_ORIGINAL . '\|' . s:conflict_THEIRS . '\|' . s:conflict_YOURS . '\|' . s:conflict_END


function! s:SetupMergeLayout(...)                                                                                  "{{{1
  " Description: Setup layout for merges
  "              Tab 1: Main window with all 4 panes (Clockwise from top-left)
  "                - Base (Original), Remote (Theirs), Local (Yours) and Merge
  "              Tab 2: Diff of Base v/s Remote
  "              Tab 3: Diff of Base v/s Local
  "              Tab 4: Diff of Remote v/s Local
  "              Tab 5: Diff of Remote v/s Merge
  "              Tab 6: Diff of Local  v/s Merge
  "
  "              +--------+----------+
  "              | Git    | Perforce |
  "              +--------+----------+
  "              | Base   | Original |
  "              | Remote | Theirs   |
  "              | Local  | Yours    |
  "              | Merge  | Merge    |
  "              +--------+----------+

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
  silent! tabonly|silent! wincmd o

  " Main merging tab
  silent! exec "b " . l:merge
  setlocal noreadonly modifiable
  let b:bufname=toupper(l:merge_str)
  silent! wincmd s
  silent! wincmd t
  silent! exec "b " . l:base
  let b:bufname=toupper(l:base_str)
  silent! wincmd v
  silent! exec "b " . l:remote
  let b:bufname=toupper(l:remote_str)
  silent! wincmd v
  silent! exec "b " . l:local
  let b:bufname=toupper(l:local_str)
  setlocal readonly
  silent! windo diffthis
  let t:guitablabel='Main'

  " Merge - Remote v/s Merge v/s Local
  silent! exec "tabe " . l:remote
  silent! wincmd v
  silent! exec "b " . l:merge
  silent! wincmd v
  silent! exec "b " . l:local
  silent! windo diffthis
  silent! wincmd h
  let t:guitablabel = l:remote_str . ' v/s ' . l:merge_str . ' v/s ' . l:local_str

  " Diff - Base vs Remote
  silent! exec "tabe " . l:base
  silent! wincmd v
  silent! exec "b " . l:remote
  silent! windo diffthis
  let t:guitablabel = l:base_str . ' v/s ' . l:remote_str

  " Diff - Base vs Local
  silent! exec "tabe " . l:base
  silent! wincmd v
  silent! exec "b " . l:local
  silent! windo diffthis
  let t:guitablabel = l:base_str . ' v/s ' . l:local_str

  " Diff - Remote vs Local
  silent! exec "tabe " . l:remote
  silent! wincmd v
  silent! exec "b " . l:local
  silent! windo diffthis
  let t:guitablabel = l:remote_str . ' v/s ' . l:local_str

  " Diff - Remote vs Merge
  silent! exec "tabe " . l:remote
  silent! wincmd v
  silent! exec "b " . l:merge
  silent! windo diffthis
  let t:guitablabel = l:remote_str . ' v/s Merge'

  " Diff - Local vs Merge
  silent! exec "tabe " . l:local
  silent! wincmd v
  silent! exec "b " . l:merge
  silent! windo diffthis
  let t:guitablabel = l:local_str . ' v/s Merge'

  set columns=400
  silent! tabdo wincmd =
  silent! tabfirst
endfunction


function! s:ConflictMotion(fwd, ...)                                                                               "{{{1
  " Description: Jump to the next/previous conflict marker.
  "              The optional argument can be used to specify any additional flags
  let l:flags = 'W' . (a:fwd ? '' : 'b') . get(a:000, 0, '')
  return search('\M'.s:conflict_ANY, l:flags)
endfunction


function! s:ConflictInnerMotion(ai, ...)                                                                           "{{{1
  " Save cursor position in case we're unable to act
  let l:curpos = getcurpos()
  let l:block  = get(a:000, 0, '')

  let l:first_line = search('\M' . s:conflict_ORIGINAL, 'bWcn')
  let l:last_line  = search('\M' . s:conflict_END, 'Wcn')

  let l:start_pat  = '\M'
  let l:end_pat    = '\M'
  if (l:block ==# 'ORIGINAL')
    let l:start_pat .= s:conflict_ORIGINAL
    let l:end_pat   .= s:conflict_THEIRS
  elseif (l:block ==# 'THEIRS')
    let l:start_pat .= s:conflict_THEIRS
    let l:end_pat   .= s:conflict_YOURS
  elseif (l:block ==# 'YOURS')
    let l:start_pat .= s:conflict_YOURS
    let l:end_pat   .= s:conflict_END
  else
    let l:start_pat .= s:conflict_ORIGINAL . '\|' . s:conflict_THEIRS . '\|' . s:conflict_YOURS
    let l:end_pat   .= s:conflict_THEIRS   . '\|' . s:conflict_YOURS  . '\|' . s:conflict_END
  endif

  " Move one line up if on the last line of conflict block
  if (getline('.') =~ '\M' . s:conflict_END)
    -
  endif

  " Find starting line of block. First search forwards, then backwards
  let l:start = search(l:start_pat, 'bWc', l:first_line)
  if (l:start == 0)
    let l:start = search(l:start_pat, 'Wc', l:last_line)
  endif
  if (l:start == 0)
    echoe "Unable to find the start of the conflict block. Are you in one?"
    return
  endif

  " Find ending line of block. First search forwards, then backwards
  let l:end = search(l:end_pat, 'Wn', l:last_line)
  if (l:end == 0)
    let l:end = search(l:end_pat, 'bWn', l:first_line)
  endif
  if (l:end == 0)
    echoe "Unable to find the end of the conflict block. Are you in one?"
    return
  endif

  " If on the 'YOURS' block, keep the final '<<<<' (by not decrementing l:end)
  if (a:ai ==# 'i')
    +
    let l:start += 1
    let l:end -= 1
  elseif (getline('.') !~ '\M' . s:conflict_YOURS)
    let l:end -= 1
  endif

  if (l:start > l:end)
    echoe "Conflict block bounds are not sensible. Something's messed up! Start=" . l:start . ", End=" . l:end
    call setpos('.', l:curpos)
    return
  endif

  execute 'normal! V' . (l:end > l:start ? (l:end - l:start) . 'j' : '')
endfunction


function! s:DiffGet(block)                                                                                         "{{{1
  " Save cursor position in case we're unable to act
  let l:curpos  = getcurpos()
  let l:curline = line('.')

  let l:original_line = search('\M' . s:conflict_ORIGINAL, 'bWc')
  let l:end_line      = search('\M' . s:conflict_END, 'Wcn')
  if (  (l:original_line > l:curline)
   \ || (l:end_line      < l:curline)
   \ )
    " Ensure that the cursor was within the conflict block
    call setpos('.', l:curpos)
    return
  endif

  let l:theirs_line = search('\M' . s:conflict_THEIRS, 'Wcn')
  let l:yours_line  = search('\M' . s:conflict_YOURS, 'Wcn')
  if (  (l:original_line == 0)
   \ || (l:theirs_line   == 0)
   \ || (l:yours_line    == 0)
   \ || (l:end_line      == 0)
   \ )
    call setpos('.', l:curpos)
    return
  endif

  if (a:block ==# 'ORIGINAL')
    let l:before_start_line = l:original_line
    let l:before_stop_line  = l:original_line
    let l:after_start_line  = l:theirs_line
    let l:after_stop_line   = l:end_line
  elseif (a:block ==# 'THEIRS')
    let l:before_start_line = l:original_line
    let l:before_stop_line  = l:theirs_line
    let l:after_start_line  = l:yours_line
    let l:after_stop_line   = l:end_line
  elseif (a:block ==# 'YOURS')
    let l:before_start_line = l:original_line
    let l:before_stop_line  = l:yours_line
    let l:after_start_line  = l:end_line
    let l:after_stop_line   = l:end_line
  else
    call setpos('.', l:curpos)
    return
  endif

  if (  (l:before_stop_line < l:before_start_line)
   \ || (l:after_stop_line  < l:after_start_line)
   \ )
    call setpos('.', l:curpos)
    return
  endif

  " Adjust 'after' based on the number of lines deleted during 'before'
  let l:after_start_line -= (l:before_stop_line - l:before_start_line + 1)
  let l:after_stop_line  -= (l:before_stop_line - l:before_start_line + 1)

  execute l:before_start_line . "," . l:before_stop_line . "g/./d"
  execute l:after_start_line  . "," . l:after_stop_line  . "g/./d"
endfunction


function! s:DiffGetOriginal()                                                                                      "{{{1
  normal! _d:call s:ConflictInnerMotion('a', 'THEIRS')
  normal! _d:call s:ConflictInnerMotion('a', 'YOURS')
  " Move up to '>>>> ORIGINAL' and delete it
  call s:ConflictMotion(0)
  delete _
endfunction

function! s:DiffGetTheirs()                                                                                        "{{{1
  normal! _d:call s:ConflictInnerMotion('a', 'ORIGINAL')
  " Delete '==== THEIRS'
  delete _
  normal! _d:call s:ConflictInnerMotion('a', 'YOURS')
endfunction

function! s:DiffGetYours()                                                                                         "{{{1
  normal! _d:call s:ConflictInnerMotion('a', 'ORIGINAL')
  normal! _d:call s:ConflictInnerMotion('a', 'THEIRS')
  " Delete '==== YOURS'
  delete _
  " Move down to '<<<<' and delete it
  call s:ConflictMotion(1)
  delete _
endfunction


function! s:CreateMergeMaps()                                                                                      "{{{1
  noremap <silent> [C :call <SID>ConflictMotion(0)<CR>
  noremap <silent> ]C :call <SID>ConflictMotion(1)<CR>

  for l:ai in ['i', 'a']
    for l:map in ['o', 'x']
      execute l:map."noremap <silent> ".l:ai. "C :call s:ConflictInnerMotion('".l:ai."')<CR>"
      execute l:map."noremap <silent> ".l:ai."oC :call s:ConflictInnerMotion('".l:ai."', 'ORIGINAL')<CR>"
      execute l:map."noremap <silent> ".l:ai."tC :call s:ConflictInnerMotion('".l:ai."', 'THEIRS')<CR>"
      execute l:map."noremap <silent> ".l:ai."yC :call s:ConflictInnerMotion('".l:ai."', 'YOURS')<CR>"
    endfor
  endfor

  nmap <silent> dgo :silent call <SID>DiffGetOriginal()<CR>
  nmap <silent> dgt :silent call <SID>DiffGetTheirs()<CR>
  nmap <silent> dgy :silent call <SID>DiffGetYours()<CR>
endfunction


function! perforce#DiffCurrentFile()                                                                               "{{{1
  " Save current settings
  let l:autoread=&l:autoread

  " Set what is required
  setl autoread

  " Execute command
  silent execute '!p4 diff "%"'

  " Restore settings
  let &l:autoread=l:autoread
endfunction
