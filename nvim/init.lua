-- This neovim configuration is meant to be used only in a standalone manner.
-- All VSCode related settings are in a separate file
if vim.g.vscode then
    return nil
end

require('packages')
require('settings')
require('keybindings')

--[[ Make pretty ]]-----------------------------------------------------------------------------------------------------
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


---[[ Local config -----------------------------------------------------------------------------------------------------
local _cwd = vim.fn.expand('<sfile>:p:h')
if (vim.fn.filereadable(_cwd .. "/lua/work/settings.lua") == 1) then
    require('work.settings')
end
if (vim.fn.filereadable(_cwd .. "/lua/work/keybindings.lua") == 1) then
   require('work.keybindings')
end
--]]
