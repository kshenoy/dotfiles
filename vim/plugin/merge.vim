" 4-way merge helper for Git and Perforce merges
"
" Usage (git config):
"   [mergetool "gvim"]
"   cmd = gvim -f "$BASE" "$REMOTE" "$LOCAL" "$MERGED" -c MergeInit
"
" Layout:
"   Tab 1 (Main):  BASE   | REMOTE | LOCAL (top), MERGED (bottom) — all diffed
"   Tab 2:         REMOTE | LOCAL (top), MERGED (bottom)
"   Tab 3:         REMOTE | MERGED
"   Tab 4:         LOCAL  | MERGED
"   Tab 5:         BASE   | REMOTE
"   Tab 6:         BASE   | LOCAL
"   Tab 7:         REMOTE | LOCAL
"
" Keymaps (buffer-local on the merge file):
"   [C  / ]C     previous / next conflict marker
"   iC  / aC     text object: whole conflict block (inner/around)
"   ibC / abC    text object: Base   (Original) conflict block (inner/around) - only on Git (diff3) and Perforce
"   ilC / alC    text object: Local  (Yours)    conflict block (inner/around)
"   irC / arC    text object: Remote (Theirs)   conflict block (inner/around)
"   dgb          accept Base   (Original) - only on Git (diff3) and Perforce
"   dgl          accept Local  (Yours)
"   dgr          accept Remote (Theirs)

let s:ctx = {}

" ── VCS detection ──────────────────────────────────────────────────────────── {{{1

function! s:DetectVCS(merge_file)
  let l:lines = readfile(a:merge_file, '', 200)
  for l:line in l:lines
    if l:line =~# '^>>>> ORIGINAL' | return 'perforce' | endif
  endfor
  for l:line in l:lines
    if l:line =~# '^|||||||' | return 'git_diff3' | endif
  endfor
  return 'git'
endfunction


" ── Context setup ──────────────────────────────────────────────────────────── {{{1

function! s:SetupCtx(vcs)
  if a:vcs ==# 'perforce'
    let s:ctx = {
      \ 'vcs': 'perforce',
      \ 'base_str': 'Original', 'remote_str': 'Theirs',
      \ 'local_str': 'Yours',   'merge_str':  'Merged',
      \ 'three_block': 1,
      \ 'P': {'b1': '^>>>> ORIGINAL', 'b2': '^==== THEIRS', 'b3': '^==== YOURS', 'end_': '^<<<<'},
      \ 'keys':  {1: 'b',        2: 'r',      3: 'l'    },
      \ 'names': {1: 'Original', 2: 'Theirs', 3: 'Yours'},
      \ }
  elseif a:vcs ==# 'git_diff3'
    let s:ctx = {
      \ 'vcs': 'git_diff3',
      \ 'base_str': 'Base',   'remote_str': 'Remote',
      \ 'local_str': 'Local', 'merge_str':  'Merged',
      \ 'three_block': 1,
      \ 'P': {'b1': '^<<<<<<< ', 'b2': '^||||||| ', 'b3': '^=======', 'end_': '^>>>>>>> '},
      \ 'keys':  {1: 'l',     2: 'b',    3: 'r'     },
      \ 'names': {1: 'Local', 2: 'Base', 3: 'Remote'},
      \ }
  else
    let s:ctx = {
      \ 'vcs': 'git',
      \ 'base_str': 'Base',   'remote_str': 'Remote',
      \ 'local_str': 'Local', 'merge_str':  'Merged',
      \ 'three_block': 0,
      \ 'P': {'b1': '^<<<<<<< ', 'b2': '^=======', 'b3': '', 'end_': '^>>>>>>> '},
      \ 'keys':  {1: 'l',     2: 'r'     },
      \ 'names': {1: 'Local', 2: 'Remote'},
      \ }
  endif
  let l:parts = [s:ctx.P.b1, s:ctx.P.b2]
  if s:ctx.three_block | call add(l:parts, s:ctx.P.b3) | endif
  call add(l:parts, s:ctx.P.end_)
  let s:ctx.P.any        = join(l:parts, '\|')
  let s:ctx.P.last_start = s:ctx.three_block ? s:ctx.P.b3 : s:ctx.P.b2
endfunction


" ── Conflict navigation ────────────────────────────────────────────────────── {{{1

function! s:ConflictMotion(fwd, ...)
  let l:flags = 'W' . (a:fwd ? '' : 'b') . (a:0 ? a:1 : '')
  return search('\M' . s:ctx.P.any, l:flags)
endfunction


" ── Conflict block detection ───────────────────────────────────────────────── {{{1

function! s:FindConflictBlock()
  let l:P     = s:ctx.P
  let l:saved = getcurpos()
  let l:b1    = search('\M' . l:P.b1, 'bWc')
  if l:b1 == 0 | call setpos('.', l:saved) | return {} | endif
  let l:b2   = search('\M' . l:P.b2,   'Wcn')
  let l:b3   = s:ctx.three_block ? search('\M' . l:P.b3, 'Wcn') : 0
  let l:end_ = search('\M' . l:P.end_, 'Wcn')
  call setpos('.', l:saved)
  if l:b2 == 0 || l:end_ == 0 | return {} | endif
  if s:ctx.three_block
    if l:b3 == 0 || !(l:b1 < l:b2 && l:b2 < l:b3 && l:b3 < l:end_) | return {} | endif
  else
    if !(l:b1 < l:b2 && l:b2 < l:end_) | return {} | endif
  endif
  return {'b1': l:b1, 'b2': l:b2, 'b3': l:b3, 'end_': l:end_}
endfunction


" ── Text objects ───────────────────────────────────────────────────────────── {{{1
" block_num: 1/2/3 for a specific block, -1 for the whole conflict block

function! s:ConflictTextObj(ai, block_num)
  let l:curpos = getcurpos()
  let l:P      = s:ctx.P

  if match(getline('.'), '\M' . l:P.end_) >= 0
    normal! k
  endif

  let l:first_line = search('\M' . l:P.b1,   'bWcn')
  let l:last_line  = search('\M' . l:P.end_,  'Wcn')
  if l:last_line == 0 | let l:last_line = line('$') | endif

  let l:is_last_block = 0
  if a:block_num == 1
    let l:start_pat = '\M' . l:P.b1
    let l:end_pat   = '\M' . l:P.b2
  elseif a:block_num == 2 && s:ctx.three_block
    let l:start_pat = '\M' . l:P.b2
    let l:end_pat   = '\M' . l:P.b3
  elseif a:block_num == 3 || (a:block_num == 2 && !s:ctx.three_block)
    let l:start_pat     = '\M' . l:P.last_start
    let l:end_pat       = '\M' . l:P.end_
    let l:is_last_block = 1
  else
    let l:s = l:P.b1 . '\|' . l:P.b2
    if s:ctx.three_block | let l:s .= '\|' . l:P.b3 | endif
    let l:start_pat = '\M' . l:s
    let l:e = l:P.b2
    if s:ctx.three_block | let l:e .= '\|' . l:P.b3 | endif
    let l:end_pat = '\M' . l:e . '\|' . l:P.end_
  endif

  let l:start = search(l:start_pat, 'bWc', l:first_line)
  if l:start == 0 | let l:start = search(l:start_pat, 'Wc', l:last_line) | endif
  if l:start == 0
    echohl ErrorMsg | echo 'Not in a conflict block' | echohl None
    call setpos('.', l:curpos) | return
  endif

  if a:block_num == -1
    let l:is_last_block = match(getline(l:start), '\M' . l:P.last_start) >= 0
  endif

  let l:end_ = search(l:end_pat, 'Wn', l:last_line)
  if l:end_ == 0
    let l:end_ = l:is_last_block ? line('$') : search(l:end_pat, 'bWn', l:first_line)
  endif
  if l:end_ == 0
    echohl ErrorMsg | echo 'Unable to find end of conflict block' | echohl None
    call setpos('.', l:curpos) | return
  endif

  if a:ai ==# 'i'
    let l:start += 1
    let l:end_  -= 1
  elseif !l:is_last_block
    let l:end_ -= 1
  endif

  if l:start > l:end_
    echohl ErrorMsg | echo 'Conflict block bounds are invalid' | echohl None
    call setpos('.', l:curpos) | return
  endif

  call cursor(l:start, 1)
  execute 'normal! V' . (l:end_ > l:start ? (l:end_ - l:start) . 'j' : '')
endfunction


" ── Accept block ───────────────────────────────────────────────────────────── {{{1

function! s:DiffGet(block_num)
  let l:b = s:FindConflictBlock()
  if empty(l:b)
    echohl ErrorMsg | echo 'Not in a conflict block' | echohl None | return
  endif
  if a:block_num == 1
    execute l:b.b2 . ',' . l:b.end_ . 'delete _'
    execute l:b.b1 .                   'delete _'
  elseif a:block_num == 2 && s:ctx.three_block
    execute l:b.b3 . ',' . l:b.end_ . 'delete _'
    execute l:b.b1 . ',' . l:b.b2   . 'delete _'
  else
    let l:last = s:ctx.three_block ? l:b.b3 : l:b.b2
    execute l:b.end_              .   'delete _'
    execute l:b.b1 . ',' . l:last .   'delete _'
  endif
endfunction


" ── Keymaps (buffer-local on the merge file) ───────────────────────────────── {{{1

function! s:CreateMergeMaps()
  for l:mode in ['n', 'x', 'o']
    execute l:mode . 'noremap <buffer> <silent> [C :<C-U>call <SID>ConflictMotion(0)<CR>'
    execute l:mode . 'noremap <buffer> <silent> ]C :<C-U>call <SID>ConflictMotion(1)<CR>'
  endfor

  for l:ai in ['i', 'a']
    execute 'onoremap <buffer> <silent> ' . l:ai . 'C :<C-U>call <SID>ConflictTextObj(''' . l:ai . ''', -1)<CR>'
    execute 'xnoremap <buffer> <silent> ' . l:ai . 'C :<C-U>call <SID>ConflictTextObj(''' . l:ai . ''', -1)<CR>'
  endfor

  for l:n in (s:ctx.three_block ? [1, 2, 3] : [1, 2])
    let l:k = s:ctx.keys[l:n]
    for l:ai in ['i', 'a']
      execute 'onoremap <buffer> <silent> ' . l:ai . l:k . 'C :<C-U>call <SID>ConflictTextObj(''' . l:ai . ''', ' . l:n . ')<CR>'
      execute 'xnoremap <buffer> <silent> ' . l:ai . l:k . 'C :<C-U>call <SID>ConflictTextObj(''' . l:ai . ''', ' . l:n . ')<CR>'
    endfor
    execute 'nnoremap <buffer> <silent> dg' . l:k . ' :<C-U>call <SID>DiffGet(' . l:n . ')<CR>'
  endfor
endfunction


" ── Layout ─────────────────────────────────────────────────────────────────── {{{1

function! s:DiffTab(label, bna, bnb)
  execute 'silent! tabe | b ' . a:bna
  execute 'silent! wincmd v | b ' . a:bnb
  silent! windo diffthis
  let t:guitablabel = a:label
endfunction

function! s:SetupMergeLayout()
  let [l:base, l:remote, l:local_, l:merged] = [argv(0), argv(1), argv(2), argv(3)]
  let [l:B, l:R, l:L, l:M] = [s:ctx.base_str, s:ctx.remote_str, s:ctx.local_str, s:ctx.merge_str]

  silent! tabonly | silent! wincmd o

  " Tab 1: BASE | REMOTE | LOCAL (top) + MERGED (bottom)
  execute 'silent! b ' . fnameescape(l:merged)
  setlocal noreadonly modifiable
  let b:bufname = toupper(l:M)
  silent! wincmd s  " split: merged to bottom (splitbelow)
  silent! wincmd t  " cursor to top-left

  execute 'silent! b ' . fnameescape(l:base)
  let b:bufname = toupper(l:B)
  silent! wincmd v
  execute 'silent! b ' . fnameescape(l:remote)
  let b:bufname = toupper(l:R)
  silent! wincmd v
  execute 'silent! b ' . fnameescape(l:local_)
  let b:bufname = toupper(l:L)
  setlocal readonly
  silent! windo diffthis
  let t:guitablabel = 'Main'

  let [l:Bbn, l:Rbn, l:Lbn, l:Mbn] = [bufnr(l:base), bufnr(l:remote), bufnr(l:local_), bufnr(l:merged)]

  " Tab 2: REMOTE | LOCAL (top) + MERGED (bottom)
  execute 'silent! tabe | b ' . l:Mbn
  setlocal noreadonly modifiable
  silent! wincmd s  " merged to bottom
  silent! wincmd t  " cursor to top-left
  execute 'silent! b ' . l:Rbn
  silent! wincmd v
  execute 'silent! b ' . l:Lbn
  silent! windo diffthis | silent! wincmd h
  let t:guitablabel = l:R . ' v/s ' . l:M . ' v/s ' . l:L

  " Tabs 3–7: pairwise diffs
  call s:DiffTab(l:R . ' v/s ' . l:M, l:Rbn, l:Mbn)
  call s:DiffTab(l:L . ' v/s ' . l:M, l:Lbn, l:Mbn)
  call s:DiffTab(l:B . ' v/s ' . l:R, l:Bbn, l:Rbn)
  call s:DiffTab(l:B . ' v/s ' . l:L, l:Bbn, l:Lbn)
  call s:DiffTab(l:R . ' v/s ' . l:L, l:Rbn, l:Lbn)

  silent! tabdo wincmd =
  silent! tabfirst

  " Per-window statuslines: in gvim, b: is evaluated in each window's own context
  let l:sl = ' %{get(b:, "bufname", fnamemodify(expand("%"), ":t"))} %=%m%r %l:%c '
  for l:t in range(1, tabpagenr('$'))
    for l:w in range(1, tabpagewinnr(l:t, '$'))
      call settabwinvar(l:t, l:w, '&statusline', l:sl)
    endfor
  endfor
endfunction


" ── Entry point ────────────────────────────────────────────────────────────── {{{1

function! s:MergeInit()
  if argc() < 4
    echohl ErrorMsg | echo 'MergeInit: requires 4 args (base remote local merged)' | echohl None | return
  endif
  let l:vcs = s:DetectVCS(argv(3))
  call s:SetupCtx(l:vcs)
  echom 'Merge mode: ' . l:vcs
  call s:SetupMergeLayout()
  wincmd b
  call s:CreateMergeMaps()
endfunction

command! MergeInit call s:MergeInit()
" }}}1
