local map = vim.keymap

--[[ Commentary ]]------------------------------------------------------------------------------------------------------
map.set({'n', 'o', 'x'}, 'gc', '<Plug>VSCodeCommentary', {remap=true})
map.set('n', 'gcc', '<Plug>VSCodeCommentaryLine', {remap=true})
