-- Highlight, edit, and navigate code
require('packer').use {
  'nvim-treesitter/nvim-treesitter',
  cond = 'vim.fn.empty(vim.g.vscode) == 1',

  run = function()
    pcall(require('nvim-treesitter.install').update { with_sync = true })
  end,

  config = function()
    require('nvim-treesitter.configs').setup {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = { 'c', 'cpp', 'lua', 'python', 'rust', 'help' },

      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = false,
          node_incremental = '<tab>',
          scope_incremental = '<c-s>',
          node_decremental = '<s-tab>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      },
    }
  end,
}

-- Additional text objects via treesitter
-- require('packer').use {
--   'nvim-treesitter/nvim-treesitter-textobjects',
--   cond = 'vim.fn.empty(vim.g.vscode) == 1',
--   after = 'nvim-treesitter',
-- }
