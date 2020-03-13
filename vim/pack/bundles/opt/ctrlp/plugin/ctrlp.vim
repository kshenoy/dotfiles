""" CtrlP related settings
"""
""" By: Kartik Shenoy
"""

let g:ctrlp_map                 = ''
let g:ctrlp_by_filename         = 1
let g:ctrlp_switch_buffer       = 'H'        " Jump to window anywhere when C-x is pressed. Pressing <CR> will just open
let g:ctrlp_root_markers        = ['P4CONFIG']
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_files           = 0
let g:ctrlp_extensions          = [ 'mixed', 'bookmarkdir', 'funky' ]
let g:ctrlp_follow_symlinks     = 1
if has('python')
  let g:ctrlp_match_func        = {'match': 'pymatcher#PyMatch'}
endif

if has('unix')
  let g:ctrlp_user_command = {
    \ 'types': {
      \ 1: ['.git', 'cd %s && git ls-files --cached --exclude-standard --others'],
      \ 2: ['.hg', 'hg --cwd %s status -numac -I . $(hg root)'],
      \ 3: ['P4CONFIG', 'cd $STEM; echo %s; cat ' .
      \     '<(command p4 have $STEM/... 2> /dev/null) ' .
      \     '<(command p4 opened | command grep add | command sed "s/#.*//" | ' .
      \       'command xargs -I{} -n1 p4 where {}) 2> /dev/null |' .
      \     'command awk "{print \$3}"']
    \ },
    \ 'fallback': "find %s -type d \\( -iname .svn -o -iname .git -o -iname .hg \\) -prune -o " .
                        \ "-type f ! \\( -name '.*' -o -iname '*.log' -o -iname '*.out' -o -iname '*.so' -o " .
                        \ "              -iname '*.cc.o' -o -iname *tags*' \\) -print " .
                        \ "| while read filename; do echo ${#filename} $filename; done " .
                        \ "| sort -n | awk '{print $2}'"
  \ }

elseif executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

let g:ctrlp_prompt_mappings = {
  \ 'PrtSelectMove("j")':   ['<c-n>'],
  \ 'PrtSelectMove("k")':   ['<c-p>'],
  \ 'PrtHistory(-1)':       ['<Down>'],
  \ 'PrtHistory(1)':        ['<Up>']
  \ }
" \ 'CreateNewFile()':      ['<c-y>'],
" \ 'MarkToOpen()':         ['<c-z>'],
" \ 'OpenMulti()':          ['<c-o>'],
" \ 'PrtInsert()':          ['<c-\>'],
" \ 'ToggleByFname()':      ['<c-d>'],
" \ 'ToggleRegex()':        ['<c-r>'],
" \ 'ToggleType(-1)':       ['<c-b>', '<c-down>'],
" \ 'ToggleType(-1)':       ['<c-h>'],
" \ 'ToggleType(1)':        ['<c-f>', '<c-up>'],
" \ 'ToggleType(1)':        ['<c-l>'],

map      <leader>f <Plug>my(Finder)
nnoremap <silent>  <Plug>my(Finder)b :CtrlPBuffer<CR>
nnoremap <silent>  <Plug>my(Finder)e :CtrlPCurWD<CR>
nnoremap <silent>  <Plug>my(Finder)f :CtrlP<CR>
nnoremap <silent>  <Plug>my(Finder)j :CtrlPMixed<CR>
nnoremap <silent>  <Plug>my(Finder)r :CtrlPMRU<CR>
nnoremap <silent>  <Plug>my(Finder)q :CtrlPQuickfix<CR>
nnoremap <silent>  <Plug>my(Finder)o :CtrlPFunky<CR>
xnoremap <silent>  <Plug>my(Finder)o :<C-U>CtrlPFunky <C-R>*<CR>
nnoremap <silent>  <leader><leader> :CtrlPBuffer<CR>

call plug#('ctrlpvim/ctrlp.vim')
call plug#('tacahiroy/ctrlp-funky')
if (has('python') || has('python3'))
  call plug#('FelikZ/ctrlp-py-matcher')
endif
