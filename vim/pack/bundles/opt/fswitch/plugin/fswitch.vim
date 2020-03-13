""" FSwitch related settings
"""
""" By: Kartik Shenoy
"""

let g:fsnonewfiles = 1
augroup FSwitch
  autocmd!
  autocmd BufEnter *.h   let b:fswitchdst = 'c,cc,cpp,tpp'
  autocmd BufEnter *.cc  let b:fswitchdst = 'hh,h'
  autocmd BufEnter *.cpp let b:fswitchdst = 'hpp,h'
  autocmd BufEnter *.tpp let b:fswitchlocs = 'reg:/src/include/,reg:|src|include/**|,ifrel:|/src/|../include|'
  autocmd BufEnter *.tpp let b:fswitchdst = 'hpp,h'
augroup END

map      <leader>a <Plug>my(FSwitch)
nnoremap <silent>  <Plug>my(FSwitch)a :FSHere<CR>
nnoremap <silent>  <Plug>my(FSwitch)h :FSLeft<CR>
nnoremap <silent>  <Plug>my(FSwitch)j :FSBelow<CR>
nnoremap <silent>  <Plug>my(FSwitch)k :FSAbove<CR>
nnoremap <silent>  <Plug>my(FSwitch)l :FSRight<CR>
nnoremap <silent>  <Plug>my(FSwitch)H <C-W><C-O>:FSSplitLeft<CR>
nnoremap <silent>  <Plug>my(FSwitch)J <C-W><C-O>:FSSplitBelow<CR>
nnoremap <silent>  <Plug>my(FSwitch)K <C-W><C-O>:FSSplitAbove<CR>
nnoremap <silent>  <Plug>my(FSwitch)L <C-W><C-O>:FSSplitRight<CR>

call plug#('derekwyatt/vim-fswitch')
