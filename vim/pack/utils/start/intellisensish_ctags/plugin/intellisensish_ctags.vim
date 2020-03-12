""" All code navigation and completion related settings that use ctags/cscope

set notagrelative                           " Filenames in tag files are relative to the directory where the tag file is
if has('path_extra')
  execute 'set tags=./tags;,./.tags;,./TAGS;,./.TAGS;,' . g:dotvim . '/tags/cpp_stl.tags'
endif
set cscopetag                                                       " Use cscope as well as tags when searching for tags
"set cscopequickfix=s-,g-,c-,d-,i-,t-,e-            " Show symbols, calls, called, includes, tags and egreps in quickfix


""" cscope mappings
" The following maps all invoke one of the following cscope search types:
"   'y'   symbol:   find all references to the token under cursor
"   'g'   global:   find global definition(s) of the token under cursor
"   'c'   calls:    find all calls to the function name under cursor
"   't'   text:     find all instances of the text under cursor
"   'e'   egrep:    egrep search for the word under cursor
"   'f'   file:     open the filename under cursor
"   'i'   includes: find files that include the filename under cursor
"   'd'   called:   find functions that the function under cursor calls
nnoremap <silent>  <C-\> :call intellisensish_ctags#CscopeMap(1)<CR>
nnoremap <silent> g<C-\> :call intellisensish_ctags#CscopeMap(0)<CR>

""" Generate ctags
nnoremap <F12> :call intellisensish_ctags#UpdateTags(0)<CR>
