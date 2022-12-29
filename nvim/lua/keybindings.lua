local map = vim.keymap.set

-- Leader and LocalLeader ----------------------------------------------------------------------------------------------
-- The leader is used for global maps and localleader for buffer/filetype specific maps
-- These need to be defined before the first map is called so they're defined in init.lua


--[[ Remapping for convenience ]]---------------------------------------------------------------------------------------
-- Move by visual lines if count is not supplied. If a count is supplied then move by normal lines.
-- This makes it easy to supply a count to line-based operations such as yank/delete without worrying about visual lines
map({'n', 'v', 'o', 's', 'x'}, 'j', "v:count == 0 ? 'gj' : 'j'", {expr=true})
map({'n', 'v', 'o', 's', 'x'}, 'gj', 'j')
map({'n', 'v', 'o', 's', 'x'}, 'k', "v:count == 0 ? 'gk' : 'k'", {expr=true})
map({'n', 'v', 'o', 's', 'x'}, 'gk', 'k')

-- Swap 'U' and 'C-R'
map('n', '<C-R>', 'U', {silent=true})
map('n', 'U',     '<C-R>', {silent=true})

-- Remap 'w' to behave as 'w' should in all cases (:h cw). Use `ce` to do what `cw` used to
map('n', 'cw', 'dwi')
map('n', 'cW', 'dWi')


--[[ Indentation and styling ]]-----------------------------------------------------------------------------------------
-- Preserve visual block after indenting, increment/decrement
map('v', '>',     '>gv')
map('v', '<',     '<gv')
map('v', '<C-A>', '<C-A>gv')
map('v', '<C-X>', '<C-X>gv')

--[[ Search and Replace ]]----------------------------------------------------------------------------------------------
-- Use very-magic (PCRE-ish) while searching
map('n', '/',   '/\\v')
map('n', '?',   '?\\v')
map('c', '%s/', '%s/\\v')
map('c', '.s/', '.s/\\v')
map('x', ':s/', ':s/\\%V\\v')

-- Replace word under the cursor. Type replacement, press `<ESC>`. Use `.` to jump to next occurence and repeat
map('n', 'c*',  '*<C-O>cgn')
map('n', 'cg*', 'g*<C-O>cgn')


--[[ Misc ]]------------------------------------------------------------------------------------------------------------
-- Fill Text Width
map('n', '<Leader>mf', "<Cmd>call utils#FillTW()<CR>", {silent=true})

if vim.g.vscode then
  require('vscode-only.keybindings')
else
  require('neovim-only.keybindings')
end
