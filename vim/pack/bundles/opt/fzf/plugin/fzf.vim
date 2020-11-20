""" FZF related settings
"""
""" By: Kartik Shenoy
"""

if ($FZF_PATH == "")
  echoe "Not loading FZF as $FZF_PATH is not set"
  finish
endif

let g:fzf_command_prefix="Fzf"
let g:fzf_layout={'down': '~30%'}
" let g:fzf_layout={'window': { 'height': 0.6, 'width': 0.8 }}
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \ }
let g:fzf_history_dir = '~/.local/share/fzf-history'
let $FZF_DEFAULT_OPTS=substitute($FZF_DEFAULT_OPTS, '--reverse', '--no-reverse', '')

" nnoremap <silent> <Plug>my(Finder)b :FzfBuffers<CR>
" nnoremap <silent> <Plug>my(Finder)o :FzfFunky<CR>
nnoremap <silent> <Plug>my(Finder)m :FzfMarks<CR>
nnoremap <silent> <Plug>my(Finder)t :FzfTags<CR>

imap <C-X><C-L> <plug>(fzf-complete-line)
inoremap <expr> <plug>(fzf-complete-file-fd) fzf#vim#complete#path('fd --color=never --follow --hidden --exclude .git --type f')
" imap <C-X><C-F> <plug>(fzf-complete-file-fd)

"" FZF + UltiSnips
nnoremap <silent> <Plug>my(Finder)y :FzfSnippet<CR>
inoremap <C-X><C-G><C-Y> <C-O>:FzfSnippet<CR>

Plug $FZF_PATH
Plug 'junegunn/fzf.vim'
Plug 'tracyone/fzf-funky'
