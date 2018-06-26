" Vim Functions file

function! utils#FoldText()                                                                                        " {{{1
  " Description: Dhruv Sagar's foldtext
  let line             = getline(v:foldstart)
  let lines_count      = v:foldend - v:foldstart + 1
  "let folddash        = v:folddashes
  let folddash         = "─"
  let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
  let foldtextend      = lines_count_text . repeat(folddash, 2)
  let nucolwidth       = &foldcolumn + (&nu || &rnu) * &numberwidth
  let foldtextstart    = strpart(line . " ", 0, (winwidth(0) - nucolwidth - foldtextend))
  let foldtextlength   = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + nucolwidth
  return foldtextstart . repeat(folddash, winwidth(0) - foldtextlength) . foldtextend
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


function! utils#SearchSaveAndRestore(...)                                                                         " {{{1
  " Description: Save and restore search strings
  if a:0 && a:1 ==# "get"
    return s:search_str
  endif

  if (@/ == "")
    let @/ = s:search_str
  else
    let s:search_str = @/
  endif
  return @/
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


function! utils#GetHighlightInfo(hl_group)                                                                        " {{{1
  " Description: Copy/modify highlight groups
  let l:hlTrace = [a:hl_group]
  redir => l:hl_info_str
  execute 'silent highlight ' . a:hl_group
  redir END

  " Find the root highlighting scheme
  let l:hl_match = matchlist(l:hl_info_str, 'links to \(\w\+\)')
  while len(l:hl_match) > 0
    call add(l:hlTrace, l:hl_match[1])
    redir => l:hl_info_str
    execute 'silent highlight ' . l:hl_match[1]
    redir END
    let l:hl_match = matchlist(l:hl_info_str, 'links to \(\w\+\)')
  endwhile
  "echo l:hlTrace

  let l:hl_info = {}
  for i in filter(split(l:hl_info_str, ' \+'), 'v:val =~ "="')
    let l:hl_info[split(i,'=')[0]] = split(i,'=')[1]
  endfor
  let l:hl_info.trace = l:hlTrace

  "echo   l:hl_info
  return l:hl_info
endfunction


function! utils#SetEnvInfo()
  " Description: Define a global variable containing current environment's name
  "              From: https://gist.github.com/romainl/4df4cde3498fada91032858d7af213c2

  if exists('g:env')
    return
  endif

  if has('win64') || has('win32') || has('win16')
    let g:env = 'windows'
  else
    let g:env = tolower(substitute(system('uname'), '\n', '', ''))
  endif
endfunction


function! utils#SetHighlightInfo(hl_group, hl_info)                                                               " {{{1
  let l:hl_cmd = 'highlight ' . a:hl_group . ' '
  for l:attr in keys(a:hl_info)
    if (l:attr ==? 'trace')
      continue
    endif
    let l:hl_cmd .= l:attr . '=' . a:hl_info[l:attr] . ' '
  endfor

  execute l:hl_cmd
endfunction
" }}}1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Temporary functions only
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! utils#_RemoveAllErrInBut_(num)                                                                          " {{{1
  " Delete everything but the entry we're interested in just the ErrIn field
  silent! execute '%g/cErrPkt/ .s/\vErrIn\=\[(\w+,\s*){' . a:num . '}(\w+)(,\s*\w+)*\]/ErrIn[' . a:num . ']=\2/g|.s/\v(ErrIn\w+\=)\[(\w+,\s*){' . a:num . '}(\w+)(,\s*\w+)*\]/\1\3/g'
endfunction
"nnoremap K :<C-U>call utils#TestFunc(v:count, v:count1)<CR>
