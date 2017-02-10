" StatusLine

function! s:Color(active, group, content)                                                                         " {{{1
  " This function only colors the input if the window is the currently focused one
  if a:active
    return '%#' . a:group . '#' . a:content . '%*'
  else
    return a:content
  endif
endfunction


function! statusline#GetColumnStr()                                                                               " {{{1
  " Get the padded column string

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

  " Ensure we have at least 1 space to the left for 2 digit column nos. ==> width >= 3
  " No idea why vim eats 1 padding space, so we add 1 more to the lower limit ==> width >= 4
  let l:width  = max([l:width, 4])

  " Subtract length of column number string
  let l:width -= len(col('.'))

  return repeat(' ', l:width)
endfunction


function! statusline#Update(winnr)                                                                                " {{{1
  let l:active  = (a:winnr == winnr())
  let l:bufnr   = winbufnr(a:winnr)
  let l:bufname = bufname(l:bufnr)

  " Handle alternate statuslines
  if (getbufvar(l:bufnr, '&buftype') ==# 'help')
    return '%#STLHelp# HELP %* ' . fnamemodify(l:bufname, ':t:r')
  elseif (l:bufname ==# '__Gundo__')
    return '%#STLHelp# Gundo %*'
  elseif (l:bufname ==# '__Gundo_Preview__')
    return '%#STLHelp# Gundo Preview %*'
  endif

  let l:stat = ''

  " Column number
  let l:stat .= s:Color(l:active, 'STLColumn', '%{statusline#GetColumnStr()}%c ')

  " Filename
  let l:stat .= s:Color(l:active, 'STLMarker', l:active ? ' »' : ' «')
  let l:stat .= ' %<'
  let l:stat .= s:Color(l:active, 'STLFilename', '%f ')
  let l:stat .= s:Color(l:active, 'STLMarker', l:active ? '« ' : '» ')

  let l:bufname = getbufvar(l:bufnr, "bufname", "")
  if (l:bufname != "")
    let l:stat .= '[' . l:bufname . '] '
  endif

  " Status: Modified, Read Only, Paste, Spell etc.
  let l:stat .= s:Color(l:active, 'STLStatus', '%{&modified ? "+" : ""}')
  let l:stat .= s:Color(l:active, 'STLStatus', '%{&readonly ? "" : ""}')
  if l:active
    let l:stat .= '%{&modified || &readonly ? " " : ""}'
    let l:stat .= s:Color(l:active, 'STLStatus', '%{&spell ? "S" : ""}')
    let l:stat .= '%{&spell && &paste ? " " : ""}'
    let l:stat .= s:Color(l:active, 'STLStatus', '%{&paste ? "P" : ""}')
  endif

  " Left/Right Separator
  let l:stat .= '%='

  " Filetype
  let l:stat .= s:Color(l:active, 'STLMarker', "← ")
  let l:stat .= "%{&filetype != '' ? &filetype : 'no ft'} "
  "let l:stat .= s:Color(l:active, "STLMarker", "\uE0A1 ")
  "let l:stat .= "%l:%c "

  return l:stat
endfunction


function! statusline#Refresh()                                                                                    " {{{1
  for nr in range(1, winnr('$'))
    call setwinvar(nr, '&statusline', '%!statusline#Update(' . nr . ')')
  endfor
endfunction
command! RefreshStatusLine :call statusline#Refresh()

function! statusline#CtrlPMain(focus, byfname, regex, prev, item, next, marked)                                   " {{{1
  let l:regex   = a:regex ? '%2*regex %*' : ''
  let l:prev    = '%#StatusLine#' . a:prev . '%*'
  let l:item    = '%#STLMarker#»%* %#STLFilename#' . (a:item == 'mru files' ? 'mru' : a:item) . '%* %#STLMarker#«%*'
  let l:next    = '%#StatusLine#' . a:next . '%*'
  let l:byfname = '%2*' . a:byfname . '%*'
  let l:dir     = '%#STLMarker#←%* %<' . fnamemodify(getcwd(), ':~')

  return '  ' . l:item . ' %=' . l:dir . ' '
  "return '  ' . l:prev . ' ' . l:item . ' ' . l:next . ' %=' . l:dir . ' '
endf


function! statusline#CtrlPProgress(str)                                                                           " {{{1
  let len = '%#Function# '.a:str.' %*'
  let dir = ' %=%<%#LineNr# '.getcwd().' %*'
  retu len.dir
endf
" }}}1

augroup StatusLine                                                                                                " {{{1
  autocmd!
  autocmd VimEnter                      * call statusline#Refresh()
  autocmd WinEnter,BufWinEnter,WinLeave * call setwinvar(winnr(), '&statusline', '%!statusline#Update(' . winnr() . ')')
augroup END

let g:ctrlp_status_func = {
  \ 'main': 'statusline#CtrlPMain',
  \ 'prog': 'statusline#CtrlPProgress'
  \}
