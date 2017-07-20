" When BufRead or BufNewFile event is triggered, pop off the tmp* filename and manually restart filetype autocommands
augroup PerforceDiffs
  autocmd!
  autocmd! BufRead    tmp* execute 'doautocmd filetypedetect BufRead '    . expand('%:r')
  autocmd! BufNewFile tmp* execute 'doautocmd filetypedetect BufNewFile ' . expand('%:r')
augroup END " PerforceDiffs
