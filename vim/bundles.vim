" Automatically install plugins
let s:plug_path=expand(g:dotvim . '/autoload/plug.vim')
if !filereadable(s:plug_path)
  execute 'silent !curl -fLo ' . s:plug_path . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  execute 'source ' . s:plug_path
  augroup Plug
    autocmd!
    autocmd VimEnter * PlugInstall --sync
  augroup END
endif

call plug#begin(expand(g:dotvim . '/pack/bundles/opt/'))

function! s:PlugCond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

runtime! macros/matchit.vim


" abolish --------------------------------------------------------------------------------------------------------- {{{1
call plug#('tpope/vim-abolish')


" ale ------------------------------------------------------------------------------------------------------------- {{{1
let g:ale_lint_on_enter=0
" let g:ale_open_list='never'
let g:ale_set_loclist=0
let g:ale_set_quickfix=0
let g:ale_set_balloons=0
let g:ale_sign_error='✗ '
let g:ale_sign_style_error='✠ '
" let g:ale_sign_warning='⚠ '
let g:ale_sign_warning='! '
let g:ale_echo_msg_format = '%linter%: %s'
let g:ale_cpp_clang_options = '-Wall -Wextra -std=c++14 -L${HOME}/.local/lib -I${HOME}/.local/include'
let g:ale_cpp_clangtidy_options = g:ale_cpp_clang_options

" Initialize list if it doesn't exist
let g:ale_cpp_clangtidy_checks = get(g:, 'ale_cpp_clangtidy_checks', [])
call add(g:ale_cpp_clangtidy_checks, '-google-build-using-namespace')
call add(g:ale_cpp_clangtidy_checks, '-llvm-header-guard')
call add(g:ale_cpp_clangtidy_checks, 'modernize-*')
call add(g:ale_cpp_clangtidy_checks, 'cpp-core-guidelines-*')

let g:ale_linters = { 'cpp' : ['clang', 'clangtidy'] }
let g:ale_fixers  = { 'cpp' : ['clang-format'] }

nnoremap [s  :ALEPreviousWrap<CR>
nnoremap ]s  :ALENextWrap<CR>
nnoremap [S  :ALEFirst<CR>
nnoremap ]S  :ALENext<CR>
nnoremap =sf :ALEFix<CR>
nnoremap =sl :ALELint<CR>
nnoremap =S  :ALEDetail<CR>
nnoremap yoS :ALEToggle<CR>

" call plug#('w0rp/ale')


" argumentative --------------------------------------------------------------------------------------------------- {{{1
call plug#('PeterRincker/vim-argumentative')


" base16 ---------------------------------------------------------------------------------------------------------- {{{1
let g:base16_shell_path=glob('~/.config/base16-shell/scripts/')
call plug#('chriskempson/base16-vim')


" commentary ------------------------------------------------------------------------------------------------------ {{{1
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine

augroup Commentary
  autocmd FileType xdefaults let &commentstring='!%s'
augroup END

call plug#('tpope/vim-commentary', {'on': '<Plug>Commentary'})


" cpp-enhanced-highlight ------------------------------------------------------------------------------------------ {{{1
let g:cpp_class_scope_highlight           = 1
let g:cpp_member_variable_highlight       = 1
let g:cpp_class_decl_highlight            = 1
let g:cpp_experimental_template_highlight = 0

highlight link cCustomFunc   cppStatement
highlight link cCustomMemvar cppStructure
highlight link cCustomClass  cCustomClassName

call plug#('octol/vim-cpp-enhanced-highlight', {'for': 'cpp'})


" CtrlP ----------------------------------------------------------------------------------------------------------- {{{1
let g:ctrlp_map                 = ''
let g:ctrlp_by_filename         = 1
let g:ctrlp_switch_buffer       = 'H'        " Jump to window anywhere when C-x is pressed. Pressing <CR> will just open
let g:ctrlp_root_markers        = ['P4CONFIG']
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_files           = 0
let g:ctrlp_extensions          = [ 'mixed', 'bookmarkdir', 'funky' ]
let g:ctrlp_follow_symlinks     = 1
if has('python')
  let g:ctrlp_match_func        = {'match': 'pymatcher#PyMatch'}
endif

if has('unix')
  let g:ctrlp_user_command = {
    \ 'types': {
      \ 1: ['.git', 'cd %s && git ls-files --cached --exclude-standard --others'],
      \ 2: ['.hg', 'hg --cwd %s status -numac -I . $(hg root)'],
      \ 3: ['P4CONFIG', 'cd $STEM; echo %s; cat ' .
      \     '<(command p4 have $STEM/... 2> /dev/null) ' .
      \     '<(command p4 opened | command grep add | command sed "s/#.*//" | ' .
      \       'command xargs -I{} -n1 p4 where {}) 2> /dev/null |' .
      \     'command awk "{print \$3}"']
    \ },
    \ 'fallback': "find %s -type d \\( -iname .svn -o -iname .git -o -iname .hg \\) -prune -o " .
                        \ "-type f ! \\( -name '.*' -o -iname '*.log' -o -iname '*.out' -o -iname '*.so' -o " .
                        \ "              -iname '*.cc.o' -o -iname *tags*' \\) -print " .
                        \ "| while read filename; do echo ${#filename} $filename; done " .
                        \ "| sort -n | awk '{print $2}'"
  \ }

elseif executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

let g:ctrlp_prompt_mappings = {
  \ 'PrtSelectMove("j")':   ['<c-n>'],
  \ 'PrtSelectMove("k")':   ['<c-p>'],
  \ 'PrtHistory(-1)':       ['<Down>'],
  \ 'PrtHistory(1)':        ['<Up>']
  \ }
" \ 'CreateNewFile()':      ['<c-y>'],
" \ 'MarkToOpen()':         ['<c-z>'],
" \ 'OpenMulti()':          ['<c-o>'],
" \ 'PrtInsert()':          ['<c-\>'],
" \ 'ToggleByFname()':      ['<c-d>'],
" \ 'ToggleRegex()':        ['<c-r>'],
" \ 'ToggleType(-1)':       ['<c-b>', '<c-down>'],
" \ 'ToggleType(-1)':       ['<c-h>'],
" \ 'ToggleType(1)':        ['<c-f>', '<c-up>'],
" \ 'ToggleType(1)':        ['<c-l>'],

map      <leader>f <Plug>my(CtrlP)
nnoremap <silent>  <Plug>my(CtrlP)b :CtrlPBuffer<CR>
nnoremap <silent>  <Plug>my(CtrlP)e :CtrlPCurWD<CR>
nnoremap <silent>  <Plug>my(CtrlP)f :CtrlP<CR>
nnoremap <silent>  <Plug>my(CtrlP)j :CtrlPMixed<CR>
nnoremap <silent>  <Plug>my(CtrlP)r :CtrlPMRU<CR>
nnoremap <silent>  <Plug>my(CtrlP)q :CtrlPQuickfix<CR>
nnoremap <silent>  <Plug>my(CtrlP)t :CtrlPTag<CR>
nnoremap <silent>  <Plug>my(CtrlP)o :CtrlPFunky<CR>
xnoremap <silent>  <Plug>my(CtrlP)o :<C-U>CtrlPFunky <C-R>*<CR>
nnoremap <silent>  <Plug>my(CtrlP)] :CtrlPtjump<CR>
vnoremap <silent>  <Plug>my(CtrlP)] :CtrlPtjumpVisual<CR>
nnoremap <silent>  <leader><leader> :CtrlPBuffer<CR>

call plug#('ctrlpvim/ctrlp.vim')
call plug#('tacahiroy/ctrlp-funky')
call plug#('FelikZ/ctrlp-py-matcher', s:PlugCond(has('python')||has('python3')))


" delimitMate ----------------------------------------------------------------------------------------------------- {{{1
augroup delimitMate_my
  autocmd!
  autocmd FileType systemverilog let b:delimitMate_quotes = "\" '"
augroup END

call plug#('Raimondi/delimitMate')


" diff-enhanced --------------------------------------------------------------------------------------------------- {{{1
call plug#('chrisbra/vim-diff-enhanced')


" DrawIt ---------------------------------------------------------------------------------------------------------- {{{1
" call plug#('vim-scripts/DrawIt')


" easy-align ------------------------------------------------------------------------------------------------------ {{{1
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

let g:easy_align_delimiters = { '>': { 'pattern': '>>\|=>\|>' },
                            \   '/': { 'pattern': '//\+\|/\*\|\*/',
                            \          'delimiter_align': 'l', 'ignore_groups': ['!Comment'] },
                            \   ']': { 'pattern': '[[\]]',
                            \          'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 },
                            \   '(': { 'pattern': '[(]',
                            \          'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 },
                            \   ')': { 'pattern': '[)]',
                            \          'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 }
                            \ }

call plug#('junegunn/vim-easy-align', {'on': ['EasyAlign', '<Plug>(EasyAlign)']})


" endwise --------------------------------------------------------------------------------------------------------- {{{1
call plug#('tpope/vim-endwise')


" exchange -------------------------------------------------------------------------------------------------------- {{{1
nmap cx  <Plug>(Exchange)
nmap cxc <Plug>(ExchangeClear)
xmap X   <Plug>(Exchange)

call plug#('tommcdo/vim-exchange', {'on': '<Plug>(Exchange'})


" express --------------------------------------------------------------------------------------------------------- {{{1
" function! s:InitVimExpress()
"   " Description: Creates operators upon startup as the plugin might not have beeen loaded at this point
"   MapExpress gs join(sort(split(v:val, '\n')), '')
" endfunction
"
" augroup BundleInit
"   autocmd!
"   autocmd VimEnter * call s:InitVimExpress()
" augroup END

" call plug#('tommcdo/vim-express')


" fswitch --------------------------------------------------------------------------------------------------------- {{{1
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


" fzf ------------------------------------------------------------------------------------------------------------- {{{1
if ($FZF_PATH != "")
  Plug $FZF_PATH
  Plug 'kshenoy/fzf.vim'

  let g:fzf_layout={'down': '~30%'}
  let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit' }
  let g:fzf_history_dir = '~/.local/share/fzf-history'
endif


" gundo ----------------------------------------------------------------------------------------------------------- {{{1
let g:gundo_preview_bottom=1
nnoremap yoU :GundoToggle<CR>

call plug#('sjl/gundo.vim', {'on': 'GundoToggle'})


" IndentLine ------------------------------------------------------------------------------------------------------ {{{1
let g:indentLine_char = "┊"

" call plug#('Yggdroot/indentLine', PlugCond(has('conceal'), {'on': 'IndentLinesToggle'}))


" ListToggle ------------------------------------------------------------------------------------------------------ {{{1
nnoremap yoL :LToggle<CR>
nnoremap yoQ :QToggle<CR>

call plug#('Valloric/ListToggle', {'on': ['LToggle', 'QToggle']})


" mark ------------------------------------------------------------------------------------------------------------ {{{1
call plug#('inkarkat/vim-ingo-library')
call plug#('inkarkat/vim-mark')

map           <leader>m        <Plug>my(Mark)
nmap <silent> <Plug>my(Mark)m  <Plug>MarkSet
xmap <silent> <Plug>my(Mark)m  <Plug>MarkSet
nmap <silent> <Plug>my(Mark)c  <Plug>MarkClear
nmap <silent> <Plug>my(Mark)r  <Plug>MarkRegex
xmap <silent> <Plug>my(Mark)r  <Plug>MarkRegex
nmap <silent> <Plug>my(Mark)n  <Plug>MarkSearchGroupNext
xmap <silent> <Plug>my(Mark)n  <Plug>MarkSearchGroupNext
nmap <silent> <Plug>my(Mark)N  <Plug>MarkSearchGroupPrev
xmap <silent> <Plug>my(Mark)N  <Plug>MarkSearchGroupPrev
nmap <silent> <Plug>my(Mark)gn <Plug>MarkSearchAnyNext
xmap <silent> <Plug>my(Mark)gn <Plug>MarkSearchAnyNext
nmap <silent> <Plug>my(Mark)gN <Plug>MarkSearchAnyPrev
xmap <silent> <Plug>my(Mark)gN <Plug>MarkSearchAnyPrev

nmap <Plug>IgnoreMarkSearchCurrentNext <Plug>MarkSearchCurrentNext
xmap <Plug>IgnoreMarkSearchCurrentNext <Plug>MarkSearchCurrentNext
nmap <Plug>IgnoreMarkSearchCurrentPrev <Plug>MarkSearchCurrentPrev
xmap <Plug>IgnoreMarkSearchCurrentPrev <Plug>MarkSearchCurrentPrev


" mucomplete ------------------------------------------------------------------------------------------------------ {{{1
let g:mucomplete#chains = {
  \ 'default': ['path', 'omni', 'keyn', 'dict', 'c-n', 'user'],
  \ 'cpp': ['tags', 'omni', 'keyn'],
  \ 'vim': ['path', 'cmd', 'keyn']
  \ }
let g:mucomplete#enable_auto_at_startup = 0
let g:mucomplete#no_popup_mappings = 0

call plug#('lifepillar/vim-mucomplete')


" origami --------------------------------------------------------------------------------------------------------- {{{1
let g:OrigamiFoldAtCol = -4

call plug#('kshenoy/vim-origami')


" parjumper ------------------------------------------------------------------------------------------------------- {{{1
" map g{ <Plug>(ParJumpBackward)
" map g} <Plug>(ParJumpForward)


" repeat ---------------------------------------------------------------------------------------------------------- {{{1
nnoremap <silent> <C-R> :<C-U>call repeat#wrap('U',v:count)<CR>
nnoremap <silent> U     :<C-U>call repeat#wrap("\<Lt>C-R>",v:count)<CR>

call plug#('tpope/vim-repeat')


" signature ------------------------------------------------------------------------------------------------------- {{{1
let g:SignatureMarkTextHLDynamic = 1
let g:SignatureMarkerTextHLDynamic = 1
if exists('*signature#marker#Goto')
  for i in range(1,9)
    execute 'nnoremap <silent> ]' . i . ' :<C-U>call signature#marker#Goto("next", ' . i .', v:count)<CR>'
    execute 'nnoremap <silent> [' . i . ' :<C-U>call signature#marker#Goto("prev", ' . i .', v:count)<CR>'
  endfor
endif

call plug#('kshenoy/vim-signature')


" sneak ----------------------------------------------------------------------------------------------------------- {{{1
" highlight link SneakPluginScope  CursorLine
" highlight link SneakPluginTarget Normal

" " Mimic Clever-f
" let g:sneak#s_next = 1

" " Disable the 's' map and next/prev maps
" map gs <Plug>Sneak_s
" map gS <Plug>Sneak_S
" " 1-character _inclusive_ Sneak (for enhanced 'f')
" map f <Plug>Sneak_f
" map F <Plug>Sneak_F
" " 1-character _exclusive_ Sneak (for enhanced 't')
" map t <Plug>Sneak_t
" map T <Plug>Sneak_T

" call plug#('justinmk/vim-sneak')


" surround -------------------------------------------------------------------------------------------------------- {{{1
call plug#('tpope/vim-surround')


" switch ---------------------------------------------------------------------------------------------------------- {{{1
nnoremap <BS> :Switch<CR>
let g:switch_mapping = ''
let g:switch_custom_definitions = [
                                \   [ 'TRUE', 'FALSE' ],
                                \   [ 'pass', 'fail'  ],
                                \   [ 'Pass', 'Fail'  ],
                                \   [ 'PASS', 'FAIL'  ]
                                \ ]

call plug#('AndrewRadev/switch.vim', {'on': 'Switch'})


" SystemVerilog --------------------------------------------------------------------------------------------------- {{{1
call plug#('WeiChungWu/vim-SystemVerilog', {'for': 'systemverilog'})


" table-mode ------------------------------------------------------------------------------------------------------ {{{1
let g:table_mode_map_prefix = '<Plug>[table]'
nnoremap yoT :TableModeToggle<CR>
call plug#('dhruvasagar/vim-table-mode', {'on': ['TableModeToggle']})


" Targets --------------------------------------------------------------------------------------------------------- {{{1
let g:targets_separators = ', . ; : + - = ~ * # / | \ & $'


" textobj-* ------------------------------------------------------------------------------------------------------- {{{1
let g:textobj_comment_no_default_key_mappings    = 1
let g:textobj_entire_no_default_key_mappings     = 1
let g:textobj_function_no_default_key_mappings   = 1
let g:textobj_indent_no_default_key_mappings     = 1
let g:textobj_line_no_default_key_mappings       = 1
let g:textobj_space_no_default_key_mappings      = 1
let g:textobj_wordcolumn_no_default_key_mappings = 1

for s:mode in ['x', 'o']
  for s:motion in ['i', 'a']
    execute s:mode . 'map ' . s:motion . 'c       <Plug>(textobj-comment-'      . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . '%       <Plug>(textobj-entire-'       . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . 'f       <Plug>(textobj-function-'     . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . 'F       <Plug>(textobj-function-'     . toupper(s:motion) . ')'
    execute s:mode . 'map ' . s:motion . 'i       <Plug>(textobj-indent-same-'  . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . 'I       <Plug>(textobj-indent-'       . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . '_       <Plug>(textobj-line-'         . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . '<Space> <Plug>(textobj-space-'        . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . 'v       <Plug>(textobj-wordcolumn-w-' . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . 'V       <Plug>(textobj-wordcolumn-W-' . s:motion          . ')'
  endfor
  execute s:mode . 'map ' . 'a' . 'C <Plug>(textobj-comment-big-a)'
endfor

"" Common-case is not to format a single line but to format the entire file.
"" Formatting the entire file doesn't need a count. Hence, if a count is given, assume we want to format lines instead.
"" Note that line formatting can also be done using gqgq
nnoremap <silent> <expr> gqq (v:count == 0 ? ":call utils#Preserve('normal gqi%')<CR>" : ":normal " . v:count . "gqq<CR>")

call plug#('kana/vim-textobj-user')
call plug#('glts/vim-textobj-comment',       {'on': '<Plug>(textobj-comment'})
call plug#('kana/vim-textobj-entire',        {'on': '<Plug>(textobj-entire'})
call plug#('kana/vim-textobj-function',      {'on': '<Plug>(textobj-function'})
call plug#('kana/vim-textobj-indent',        {'on': '<Plug>(textobj-indent'})
call plug#('kana/vim-textobj-line',          {'on': '<Plug>(textobj-line'})
call plug#('saihoooooooo/vim-textobj-space', {'on': '<Plug>(textobj-space'})
call plug#('rhysd/vim-textobj-word-column',  {'on': '<Plug>(textobj-wordcolumn'})

" tmux-focus-events ----------------------------------------------------------------------------------------------- {{{1
if !has('gui_running')
  call plug#('tmux-plugins/vim-tmux-focus-events')
endif

" ultiSnips ------------------------------------------------------------------------------------------------------- {{{1
let g:UltiSnipsEditSplit = "vertical"
" Location of snippets
execute 'let g:UltiSnipsSnippetDirectories=["' . g:dotvim . '/pack/settings/start/UltiSnips/snippets"]'
let g:UltiSnipsEnableSnipMate=0
" <C-X> is insert-mode completion so using <C-X><C-S> feels natural for snippets
let g:UltiSnipsExpandTrigger='<C-X><C-S>'
let g:UltiSnipsListSnippets='<C-X>g<C-S>'
let g:UltiSnipsJumpForwardTrigger='<Tab>'
let g:UltiSnipsJumpBackwardTrigger='<S-Tab>'

call plug#('SirVer/ultisnips', s:PlugCond(has('python')||has('python3')))


" unimpaired ------------------------------------------------------------------------------------------------------ {{{1
call plug#('tpope/vim-unimpaired')


" vinegar --------------------------------------------------------------------------------------------------------- {{{1
nnoremap - <Plug>VinegarUp

call plug#('tpope/vim-vinegar')


" visual-increment ------------------------------------------------------------------------------------------------ {{{1
call plug#('triglav/vim-visual-increment', {'on': '<Plug>VisualIncrement'})


" wordmotion ------------------------------------------------------------------------------------------------------ {{{1
if has('gui_running')
  let g:wordmotion_mappings = {
  \ 'w':          '<A-w>',
  \ 'b':          '<A-b>',
  \ 'e':          '<A-e>',
  \ 'ge':         'g<A-e>',
  \ 'aw':         'a<A-w>',
  \ 'iw':         'i<A-w>',
  \ '<C-R><C-W>': '<C-R><A-w>'
  \ }
else
  let g:wordmotion_mappings = {
  \ 'w':          'w',
  \ 'b':          'b',
  \ 'e':          'e',
  \ 'ge':         'ge',
  \ 'aw':         'aw',
  \ 'iw':         'iw',
  \ '<C-R><C-W>': '<C-R>w'
  \ }
endif

call plug#('chaoren/vim-wordmotion')
" }}}1

call plug#end()
