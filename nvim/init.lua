-- #+TITLE: neovim configuration
-- #+PROPERTY: header-args+ :results output silent :noweb tangle :comments both :mkdirp yes :padline yes :tangle (concat (or (getenv "XDG_CONFIG_HOME") (concat (getenv "HOME") "/.config")) "/nvim/init.lua")
-- #+TODO: FIXME | FIXED

-- This neovim configuration is meant to be used only in a stand-alone manner. All VSCode related settings are in a separate file

-- [[file:../dotfiles/nvim.org::+begin_src lua][No heading:1]]
if vim.g.vscode then
    return nil
end
-- No heading:1 ends here

-- Package management
-- :PROPERTIES:
-- :header-args+: :tangle (concat (or (getenv "XDG_CONFIG_HOME") (concat (getenv "HOME") "/.config")) "/nvim/lua/packages.lua")
-- :END:

-- Put all packages in a separate file

-- [[file:../dotfiles/nvim.org::*Package management][Package management:1]]
require('packages')
-- Package management:1 ends here

-- Settings
-- :PROPERTIES:
-- :header-args+: :tangle (concat (or (getenv "XDG_CONFIG_HOME") (concat (getenv "HOME") "/.config")) "/nvim/lua/settings.lua")
-- :END:

-- Put all settings in a separate file

-- [[file:../dotfiles/nvim.org::*Settings][Settings:1]]
require('settings')
-- Settings:1 ends here

-- Keybindings
-- :PROPERTIES:
-- :header-args+: :tangle (concat (or (getenv "XDG_CONFIG_HOME") (concat (getenv "HOME") "/.config")) "/nvim/lua/keybindings.lua")
-- :END:

-- [[file:../dotfiles/nvim.org::*Keybindings][Keybindings:1]]
require('keybindings')
-- Keybindings:1 ends here

-- Make pretty
-- Automatically load the same base16 theme as the shell

-- [[file:../dotfiles/nvim.org::*Make pretty][Make pretty:1]]
vim.api.nvim_create_autocmd({"VimEnter", "FocusGained"}, {
  desc = "Automatically load the same base16 theme as the shell",
  callback = function()
    vim.cmd "if filereadable(expand('~/.vimrc_background')) | silent! source ~/.vimrc_background | endif"
  end,
  nested = true  -- required to trigger the Colorscheme autocmd to make any tweaks to the colorscheme
})
-- Make pretty:1 ends here



-- Tweak solarized-light theme

-- [[file:../dotfiles/nvim.org::*Make pretty][Make pretty:2]]
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = 'base16-solarized-light',
  callback = function()
    vim.api.nvim_set_hl(0, 'StatusLine', {link='LineNr'})
    -- Need to update StatusLineNC's bg color
  end
})
-- Make pretty:2 ends here

if (vim.fn.filereadable("lua/work/settings.lua") == 1) then
    require('work.settings')
end
if (vim.fn.filereadable("lua/work/keybindings.lua") == 1) then
    require('work.keybindings')
end
