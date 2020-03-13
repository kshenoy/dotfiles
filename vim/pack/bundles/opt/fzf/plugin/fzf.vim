""" FZF related settings
"""
""" By: Kartik Shenoy
"""

if ($FZF_PATH != "")
  let g:fzf_layout={'down': '~30%'}
  let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit'
    \ }
  let g:fzf_history_dir = '~/.local/share/fzf-history'
  let $FZF_DEFAULT_OPTS=substitute($FZF_DEFAULT_OPTS, '--reverse', '--no-reverse', '')

  nnoremap <silent> <Plug>my(Finder)t :Tags<CR>
  nnoremap <silent> <Plug>my(Finder)y :Snippet<CR>
  nnoremap <silent> <Plug>my(Finder)m :call fzf#vim#marks()<CR>
  imap              <C-X><C-L>        <plug>(fzf-complete-line)

  inoremap <expr> <plug>(fzf-complete-file-fd) fzf#vim#complete#path('fd --color=never --follow --hidden --exclude .git --type f')
  " imap     <C-X><C-F> <plug>(fzf-complete-file-fd)

  Plug $FZF_PATH
  Plug 'junegunn/fzf.vim'
else
  echoe "$FZF_PATH is not set"
endif
