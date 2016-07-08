" Unix graph files - Recognize .gv files as ft=dot
autocmd! BufEnter *.gv set ft=dot

" Recognize .x files as SystemVerilog
autocmd! BufEnter *.x,*.d set ft=systemverilog

" When BufRead or BufNewFile event is triggered, pop off the tmp* filename and manually restart filetype autocommands
augroup PerforceDiffs
  autocmd!
  autocmd! BufRead    tmp* execute 'doautocmd filetypedetect BufRead ' . expand('%:r')
  autocmd! BufNewFile tmp* execute 'doautocmd filetypedetect BufNewFile ' . expand('%:r')
augroup END " PerforceDiffs
