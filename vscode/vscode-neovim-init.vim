" VSCode+Neovim integration - https://github.com/CozyPenguin/vscode-nvim-setup

""" Commentary ---------------------------------------------------------------------------------------------------------
nnoremap gc  <Plug>VSCodeCommentary
onoremap gc  <Plug>VSCodeCommentary
xnoremap gc  <Plug>VSCodeCommentary
nnoremap gcc <Plug>VSCodeCommentaryLine

""" Leader Mode --------------------------------------------------------------------------------------------------------
nnoremap <C-Space><C-B> <Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>
