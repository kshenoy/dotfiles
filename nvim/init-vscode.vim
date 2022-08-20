" VSCode+Neovim integration - https://github.com/CozyPenguin/vscode-nvim-setup

" let mapleader = "\<Space>"

nnoremap z= <Cmd>call VSCodeNotify('keyboard-quickfix.openQuickFix')<CR>

" VSCodeCommentary
nnoremap gc  <Plug>VSCodeCommentary
onoremap gc  <Plug>VSCodeCommentary
xnoremap gc  <Plug>VSCodeCommentary
nnoremap gcc <Plug>VSCodeCommentaryLine
