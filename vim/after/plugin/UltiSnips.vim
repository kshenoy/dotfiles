" UltiSnips needs Python!
if !has('python') && !has('python3')
  finish
endif

function! s:InsertSkeleton()
  execute "normal! i_skeleton\<C-R>=UltiSnips#ExpandSnippet()\<CR>"

  if !g:ulti_expand_res
    silent! undo
  endif

  return g:ulti_expand_res
endfunction " s:InsertSkeleton


augroup UltiSnips_Custom
  autocmd!
  autocmd BufNewFile * silent! call s:InsertSkeleton()
augroup END
