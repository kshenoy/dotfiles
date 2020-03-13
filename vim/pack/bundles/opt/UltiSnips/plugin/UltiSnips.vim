""" UltiSnips related settings
"""
""" By: Kartik Shenoy
"""

let g:UltiSnipsEditSplit = "vertical"
" Location of snippets
execute 'let g:UltiSnipsSnippetDirectories=["' . g:dotvim . '/pack/settings/start/UltiSnips/snippets"]'
let g:UltiSnipsEnableSnipMate=0
" <C-X> is insert-mode completion so using <C-X><C-Y> feels natural for snippets
let g:UltiSnipsExpandTrigger='<C-X><C-Y>'
let g:UltiSnipsListSnippets='<C-X><C-G><C-Y>'
let g:UltiSnipsJumpForwardTrigger='<Tab>'
let g:UltiSnipsJumpBackwardTrigger='<S-Tab>'

if has('python3')
  call plug#('SirVer/ultisnips')
endif
