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

call plug#begin(expand(g:dotvim . '/bundles/'))

runtime! macros/matchit.vim
call plug#('tpope/vim-abolish')
call plug#('PeterRincker/vim-argumentative')
packadd ctrlp                                                                  " pack/bundles/opt/ctrlp/plugin/ctrlp.vim
call plug#('vim-scripts/DrawIt')
call plug#('tpope/vim-endwise')
packadd fswitch                                                            " pack/bundles/opt/fswitch/plugin/fswitch.vim
packadd fzf                                                                        " pack/bundles/opt/fzf/plugin/fzf.vim
call plug#('tpope/vim-surround')
call plug#('WeiChungWu/vim-SystemVerilog', {'for': 'systemverilog'})
packadd text-obj                                                         " pack/bundles/opt/text-obj/plugin/text-obj.vim
call plug#('vim-scripts/TWiki-Syntax', {'for': 'twiki'})
packadd UltiSnips                                                      " pack/bundles/opt/UltiSnips/plugin/UltiSnips.vim
call plug#('tpope/vim-unimpaired')
call plug#('triglav/vim-visual-increment', {'on': '<Plug>VisualIncrement'})


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


" delimitMate ----------------------------------------------------------------------------------------------------- {{{1
augroup delimitMate_my
  autocmd!
  autocmd FileType systemverilog let b:delimitMate_quotes = "\" '"
augroup END

call plug#('Raimondi/delimitMate')


" easy-align ------------------------------------------------------------------------------------------------------ {{{1
nmap <leader>= <Plug>(EasyAlign)
xmap <leader>= <Plug>(EasyAlign)

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


" IndentLine ------------------------------------------------------------------------------------------------------ {{{1
let g:indentLine_char = "┊"
if has('conceal')
  call plug#('Yggdroot/indentLine', {'on': 'IndentLinesToggle'})
endif

nnoremap yoI :IndentLinesToggle<CR>


" ListToggle ------------------------------------------------------------------------------------------------------ {{{1
call plug#('Valloric/ListToggle', {'on': ['LToggle', 'QToggle']})

nnoremap yoL :LToggle<CR>
nnoremap yoQ :QToggle<CR>


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
  \ 'default': ['ulti', 'path', 'omni', 'keyn', 'dict', 'c-n', 'user'],
  \ 'cpp': ['ulti', 'tags', 'omni', 'keyn'],
  \ 'vim': ['ulti', 'path', 'cmd', 'keyn']
  \ }
let g:mucomplete#enable_auto_at_startup = 0
let g:mucomplete#no_popup_mappings = 0

" Create dummy mapping to prevent mucomplete from mapping the <Tab> key
imap <nop> <plug>(MUcompleteFwd)
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


" switch ---------------------------------------------------------------------------------------------------------- {{{1
nnoremap <BS> :Switch<CR>
let g:switch_mapping = ''
let g:switch_custom_definitions = [
                                \ [ 'TRUE',       'FALSE'       ],
                                \ [ 'pass',       'fail'        ],
                                \ [ 'Pass',       'Fail'        ],
                                \ [ 'PASS',       'FAIL'        ],
                                \ [ 'shared_ptr', 'make_shared' ],
                                \ [ 'unique_ptr', 'make_unique' ],
                                \ [ 'weak_ptr',   'make_weak'   ],
                                \ [ 'boost',      'std'         ],
                                \ ]

call plug#('AndrewRadev/switch.vim', {'on': 'Switch'})


" table-mode ------------------------------------------------------------------------------------------------------ {{{1
let g:table_mode_map_prefix = '<Plug>[table]'
nnoremap yoT :TableModeToggle<CR>
call plug#('dhruvasagar/vim-table-mode', {'on': ['TableModeToggle']})


" tmux-focus-events ----------------------------------------------------------------------------------------------- {{{1
if !has('gui_running')
  call plug#('tmux-plugins/vim-tmux-focus-events')
endif


" undotree -------------------------------------------------------------------------------------------------------- {{{1
let g:undotree_WindowLayout=2
let g:undotree_ShortIndicators=1
let g:undotree_SetFocusWhenToggle=1
call plug#('mbbill/undotree', {'on': 'UndotreeToggle'})
nnoremap yoU :UndotreeToggle<CR>


" vinegar --------------------------------------------------------------------------------------------------------- {{{1
nnoremap - <Plug>VinegarUp

call plug#('tpope/vim-vinegar')


" wordmotion ------------------------------------------------------------------------------------------------------ {{{1
let g:wordmotion_mappings = {
\ 'w':          '<A-w>',
\ 'b':          '<A-b>',
\ 'e':          '<A-e>',
\ 'ge':         'g<A-e>',
\ 'aw':         'a<A-w>',
\ 'iw':         'i<A-w>',
\ '<C-R><C-W>': '<C-R><A-w>'
\ }

call plug#('chaoren/vim-wordmotion')
" }}}1

call plug#end()
