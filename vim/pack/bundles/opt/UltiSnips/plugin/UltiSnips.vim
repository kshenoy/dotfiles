""" UltiSnips related settings
"""
""" By: Kartik Shenoy
"""

" UltiSnips needs Python3!
if !has('python3')
  " echoe "Not loading UltiSnips as python3 is not available"
  finish
endif

let g:UltiSnipsEditSplit = "tabdo"
" Location of snippets
execute 'let g:UltiSnipsSnippetDirectories=["' . g:dotvim . '/pack/bundles/opt/UltiSnips/snippets"]'
let g:UltiSnipsEnableSnipMate=0
" <C-X> is insert-mode completion so using <C-X><C-Y> feels natural for snippets
let g:UltiSnipsExpandTrigger='<C-X><C-Y>'

"" I'm using FZF for listing snippets
" let g:UltiSnipsListSnippets='<C-X><C-G><C-Y>'
let g:UltiSnipsListSnippets=''

let g:UltiSnipsJumpForwardTrigger='<Tab>'
let g:UltiSnipsJumpBackwardTrigger='<S-Tab>'

call plug#('SirVer/ultisnips')
