-- Package management
-- :PROPERTIES:
-- :header-args+: :tangle (concat (or (getenv "XDG_CONFIG_HOME") (concat (getenv "HOME") "/.config")) "/nvim/lua/packages.lua")
-- :END:
-- Put all packages in a separate file

-- [[file:../dotfiles/nvim.org::*Package management][Package management:1]]
require('packages')
-- Package management:1 ends here

-- Neovim-only config
-- :PROPERTIES:
-- :header-args+: :tangle (concat (or (getenv "XDG_CONFIG_HOME") (concat (getenv "HOME") "/.config")) "/nvim/lua/neovim-only.lua")
-- :END:

-- Load Neovim-only settings

-- [[file:../dotfiles/nvim.org::*Neovim-only config][Neovim-only config:1]]
if not vim.g.vscode then
    require('neovim-only')
end
-- Neovim-only config:1 ends here

-- VSCode-only config
-- :PROPERTIES:
-- :header-args+: :tangle (concat (or (getenv "XDG_CONFIG_HOME") (concat (getenv "HOME") "/.config")) "/nvim/lua/vscode-only.lua")
-- :END:

-- Load VSCode-only settings

-- [[file:../dotfiles/nvim.org::*VSCode-only config][VSCode-only config:1]]
if vim.g.vscode then
    require('vscode-only')
end
-- VSCode-only config:1 ends here
