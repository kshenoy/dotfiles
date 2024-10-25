-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

local packer = require('packer')
local packer_compile_path = vim.fn.stdpath('config') .. '/lua/packages/' .. 'packer_compiled.lua'

-- Easiest way to use packer is to use the 'startup' function which can take a table of plugin specifications for each
-- plugin. It'll do everything - install, configure etc. The downside is, everything is in one place, in one file
-- Here, instead of packer.startup, I use separate calls to packer.init and packer.use. This allows me to have
-- everything related to a plugin in its own separate file and I keep only 'packer' related stuff in this file
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = 'single' })
        end,
    },
    compile_path = packer_compile_path,
})

packer.use 'wbthomason/packer.nvim' -- Let the package manager bootstrap itself

require('packages.Comment')  -- "gc" to comment visual regions/lines
require('packages.nvim-surround')
require('packages.leap')
require('packages.mini')
require('packages.vim_p4_files')
require('packages.catppuccin')  -- colorscheme
require('packages.vim-repeat')
require('packages.vim-unimpaired')  -- complementary pairs of mappings
require('packages.vim-abolish')  -- smarter abbrev, substitutes and case-coercions
require('packages.vim-endwise')  -- add 'end' structures automatically
require('packages.nvim-web-devicons')
require('packages.lualine')
require('packages.indent-blankline')  -- add indentation guides even on blank lines
-- require('packages.lsp')  -- LSP Configuration & Plugins
-- require('packages.cmp')  -- Autocompletion
-- require('packages.treesitter')  -- Highlight, edit, and navigate code
require('packages.telescope')


-- Add custom plugins to packer from /nvim/lua/custom/plugins.lua
local has_plugins, plugins = pcall(require, 'custom.plugins')
if has_plugins then
  plugins(packer.use)
end

if is_bootstrap then
  require('packer').sync()
elseif vim.fn.empty(vim.fn.glob(packer_compile_path)) == 0 then
  require('packages.packer_compiled')
end


-- When we are bootstrapping a configuration, it doesn't make sense to execute the rest of the init.lua.
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '==================================================================================='
  print '    Plugins are being installed. Wait until Packer completes, then restart nvim'
  print '==================================================================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
