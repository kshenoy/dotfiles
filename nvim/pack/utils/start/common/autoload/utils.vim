"=======================================================================================================================
function! utils#FillTW(...)                                                                                        "{{{1
  " Description: Insert spaces to make the current line as wide as specified by textwidth or the supplied width
  " Arguments: When provided an argument, use that character as the fill char
  let l:filler = (a:0 > 0 ? a:1 : nr2char(getchar()))
  execute "normal! i" . repeat(l:filler, &textwidth - len(getline('.')))
  silent! call repeat#set(":call utils#FillTW('" . l:filler . "')\<CR>", -1)
endfunction
