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
  -- Make pretty -------------------------------------------------------------------------------------------------------
  -- Automatically load the same base16 theme as the shell
  vim.api.nvim_create_autocmd({"VimEnter", "FocusGained"}, {
    desc = "Automatically load the same base16 theme as the shell",
    callback = function()
      vim.cmd "if filereadable(expand('~/.vimrc_background')) | silent! source ~/.vimrc_background | endif"
    end,
    nested = true  -- required to trigger the Colorscheme autocmd to make any tweaks to the colorscheme
  })

  -- Tweak solarized-light theme
  vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = 'base16-solarized-light',
    callback = function()
      vim.api.nvim_set_hl(0, 'StatusLine', {link='LineNr'})
      -- Need to update StatusLineNC's bg color
    end
  })

  -- Local config ------------------------------------------------------------------------------------------------------
  local cfg = vim.fn.stdpath('config')
  if (vim.fn.filereadable(cfg .. "/lua/work/settings.lua") == 1) then
      require('work.settings')
  end
  if (vim.fn.filereadable(cfg .. "/lua/work/keybindings.lua") == 1) then
    require('work.keybindings')
  end
end

