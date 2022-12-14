--  Lua interface to vim-plug by https://dev.to/vonheikemen/neovim-using-vim-plug-in-lua-3oom
local plug = require('plug')
local fn = vim.fn
local map = vim.keymap


plug.begin(vim.fn.stdpath('data')..'/plugged')

plug('tpope/vim-repeat')


plug('kylechui/nvim-surround', {
  config = function()
    require('nvim-surround').setup({
      keymaps = {
        normal = "gs",
        normal_cur = "gss",
        normal_line = "gS",
        normal_cur_line = "gSS",
        visual = "gs",
        visual_line = "gS",
      }
    })
  end,
})


plug('ggandor/leap.nvim', {
  config = function()
    map.set({'n', 'x', 'o'}, 's', '<Plug>(leap-forward-to)', {remap=true})
    map.set({'n', 'x', 'o'}, 'S', '<Plug>(leap-backward-to)', {remap=true})
    if not vim.g.vscode then
      map.set('n', 'ys', '<Plug>(leap-cross-window)', {remap=true})
    end
  end,
})
-- plug('ggandor/flit.nvim', {
--   config = function()
--     require('flit').setup()
--   end
-- })


if not vim.g.vscode then
  plug('tpope/vim-abolish')
  plug('tpope/vim-endwise')
  plug('tpope/vim-unimpaired')
  plug('nvim-lua/plenary.nvim')
  plug('RRethy/nvim-base16')
  plug('kyazdani42/nvim-web-devicons')

  ---[[ Catpuccin ------------------------------------------------------------------------------------------------------
  plug('catppuccin/nvim', {
    config = function()
      require("catppuccin").setup({
        flavour = "frappe", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "frappe",
        },
        transparent_background = false,
        dim_inactive = {
          enabled = true,
        },
      })
      vim.cmd('colorscheme catppuccin')
    end,
  })
  ---]]

  ---[[ Comment --------------------------------------------------------------------------------------------------------
  plug('numToStr/Comment.nvim', {
    config = function()
      require('Comment').setup()
    end,
  })
  --]]

  ---[[ FZF ------------------------------------------------------------------------------------------------------------
  plug('ibhagwan/fzf-lua', {
    config = function()
      require('fzf-lua').setup({
        winopts = {
          preview = {
            hidden = 'hidden',  -- The previewer is a bit slower than fzf.vim so disabling it by default
          }
        }
      })

      map.set('n', '<Plug>(leader-buffer-map)b', "<Cmd>lua require('fzf-lua').buffers({ winopts = { preview = { hidden='hidden' }}})<CR>", {desc="Switch buffer", silent=true})
      map.set('n', '<Plug>(leader-file-map)f',   "<Cmd>lua require('fzf-lua').files()<CR>", {desc="Find file", silent=true})
      map.set('n', '<Plug>(leader-file-map)F',   "<Cmd>lua require('fzf-lua').files({cwd='.'})<CR>", {desc="Find file from here", silent=true})
      map.set('n', '<Plug>(leader-file-map)r',   "<Cmd>lua require('fzf-lua').oldfiles()<CR>", {desc="Recent files", silent=true})
      map.set('n', "<Leader>'",                  "<Cmd>lua require('fzf-lua').resume()<CR>",  {desc="Resume last Fzf op", silent=true})
      map.set('n', '<Plug>(leader-help-map)b',   "<Cmd>lua require('fzf-lua').keymaps()<CR>", {desc="Describe bindings", silent=true})
      map.set('n', '<Plug>(leader-open-map)l',   "<Cmd>lua require('fzf-lua').loclist()<CR>",  {desc="Open Location List", silent=true})
      map.set('n', '<Plug>(leader-open-map)q',   "<Cmd>lua require('fzf-lua').quickfix()<CR>", {desc="Open QuickFix", silent=true})
      map.set('n', '<Plug>(leader-open-map)l',   "<Cmd>lua require('fzf-lua').loclist()<CR>",  {desc="Open Location List", silent=true})
      map.set('n', '<Plug>(leader-open-map)q',   "<Cmd>lua require('fzf-lua').quickfix()<CR>", {desc="Open QuickFix", silent=true})
      map.set('n', '<Plug>(leader-search-map)b', "<Cmd>lua require('fzf-lua').blines()<CR>", {desc="Search current buffer", silent=true})
      map.set('n', '<Plug>(leader-search-map)B', "<Cmd>lua require('fzf-lua').lines()<CR>", {desc="Search all buffers", silent=true})
    end,
  })
  --]]

  ---[[ Lualine --------------------------------------------------------------------------------------------------------
  plug('nvim-lualine/lualine.nvim', {
    config = function()
      require('lualine').setup({
        options = {
          icons_enabled = true,
        },
      })
    end,
  })
  --]]

  ---[[ Ouroboros ------------------------------------------------------------------------------------------------------
  plug('jakemason/ouroboros', {
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      vim.api.nvim_create_autocmd({"Filetype"}, {
        desc = "Switch between header and implementation",
        callback = function()
          map.set('n', "<LocalLeader>a", "<Cmd>Ouroboros<CR>", {desc="Switch between header and implementation", buffer=true, silent=true})
        end,
      })
    end,
  })
  --]]
end

plug.ends()
