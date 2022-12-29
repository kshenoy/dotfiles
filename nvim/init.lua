-- Leader and LocalLeader. The leader is used for global maps and localleader for buffer/filetype specific maps
-- These keybindings need to be defined before the first map is called so placing them here before everything else
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

if not vim.g.vscode then
  require('neovim-only.settings')
end

require('packages')
require('keybindings')

if not vim.g.vscode then
  -- Local config ------------------------------------------------------------------------------------------------------
  local cfg = vim.fn.stdpath('config')
  if (vim.fn.filereadable(cfg .. "/lua/work/settings.lua") == 1) then
      require('work.settings')
  end
  if (vim.fn.filereadable(cfg .. "/lua/work/keybindings.lua") == 1) then
    require('work.keybindings')
  end
end
