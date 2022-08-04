-- [[file:../../dotfiles/nvim.org::*VSCode-only config][VSCode-only config:3]]
vim.keymap.set('n', 'z=', "<Cmd>call VSCodeNotify('keyboard-quickfix.openQuickFix')<Cr>")
-- VSCode-only config:3 ends here

-- VSCodeCommentary

-- [[file:../../dotfiles/nvim.org::*VSCodeCommentary][VSCodeCommentary:1]]
vim.keymap.set('n', 'gc',  "<Plug>VSCodeCommentary")
vim.keymap.set('o', 'gc',  "<Plug>VSCodeCommentary")
vim.keymap.set('x', 'gc',  "<Plug>VSCodeCommentary")
vim.keymap.set('n', 'gcc', "<Plug>VSCodeCommentaryLine")
-- VSCodeCommentary:1 ends here
