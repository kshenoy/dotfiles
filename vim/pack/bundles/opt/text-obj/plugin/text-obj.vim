""" Text Objects related settings
"""
""" By: Kartik Shenoy
"""

let g:textobj_comment_no_default_key_mappings    = 1
let g:textobj_entire_no_default_key_mappings     = 1
let g:textobj_function_no_default_key_mappings   = 1
let g:textobj_indent_no_default_key_mappings     = 1
let g:textobj_line_no_default_key_mappings       = 1
let g:textobj_space_no_default_key_mappings      = 1
let g:textobj_wordcolumn_no_default_key_mappings = 1

for s:mode in ['x', 'o']
  for s:motion in ['i', 'a']
    execute s:mode . 'map ' . s:motion . 'c       <Plug>(textobj-comment-'      . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . '%       <Plug>(textobj-entire-'       . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . 'f       <Plug>(textobj-function-'     . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . 'F       <Plug>(textobj-function-'     . toupper(s:motion) . ')'
    execute s:mode . 'map ' . s:motion . 'i       <Plug>(textobj-indent-same-'  . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . 'I       <Plug>(textobj-indent-'       . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . '_       <Plug>(textobj-line-'         . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . '<Space> <Plug>(textobj-space-'        . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . 'v       <Plug>(textobj-wordcolumn-w-' . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . 'V       <Plug>(textobj-wordcolumn-W-' . s:motion          . ')'
  endfor
  execute s:mode . 'map ' . 'a' . 'C <Plug>(textobj-comment-big-a)'
endfor

"" Common-case is not to format a single line but to format the entire file.
"" Formatting the entire file doesn't need a count. Hence, if a count is given, assume we want to format lines instead.
"" Note that line formatting can also be done using gqgq
nnoremap <silent> <expr> gqq (v:count == 0 ? ":call utils#Preserve('normal gqi%')<CR>" : ":normal " . v:count . "gqq<CR>")

call plug#('kana/vim-textobj-user')
call plug#('glts/vim-textobj-comment',       {'on': '<Plug>(textobj-comment'})
call plug#('kana/vim-textobj-entire',        {'on': '<Plug>(textobj-entire'})
call plug#('kana/vim-textobj-function',      {'on': '<Plug>(textobj-function'})
call plug#('kana/vim-textobj-indent',        {'on': '<Plug>(textobj-indent'})
call plug#('kana/vim-textobj-line',          {'on': '<Plug>(textobj-line'})
call plug#('saihoooooooo/vim-textobj-space', {'on': '<Plug>(textobj-space'})
call plug#('rhysd/vim-textobj-word-column',  {'on': '<Plug>(textobj-wordcolumn'})
