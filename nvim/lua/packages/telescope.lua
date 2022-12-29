-- See `:help telescope`, `:help telescope.setup()` and `:help telescope.builtin`

-- Fuzzy Finder (files, lsp, etc)
require('packer').use {
  'nvim-telescope/telescope.nvim',
  cond = 'vim.fn.empty(vim.g.vscode) == 1',

  branch = '0.1.x',
  requires = { 'nvim-lua/plenary.nvim' },

  config = function()
    vim.cmd.packadd { 'plenary.nvim', bang = true }
    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
    }

    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')

    local map = vim.keymap.set
    local tb  = require('telescope.builtin')

    map('n', "<Leader>'", tb.resume,            { desc = 'Resume last Telescope operation' })
    map('n', '<Leader>:', tb.commands,          { desc = 'Commands' })
    map('n', '<Leader>;', '<Cmd>Telescope<CR>', { desc = 'Telescope picker' })

    ---[[ Buffer bindings
    map('n', '<Plug>(leader-buffer-map)b', tb.buffers,             { desc = 'Switch to [b]uffers' })
    map('n', '<Plug>(leader-buffer-map)t', tb.current_buffer_tags, { desc = "Search current buffer's tags" })
    --]]

    ---[[ File bindings
    map('n', '<Plug>(leader-file-map)f', tb.find_files, { desc = '[F]ind [f]iles' })
    map('n', '<Plug>(leader-file-map)r', tb.oldfiles,   { desc = 'Open [f]iles that have been opened [r]ecently' })
    --]]

    ---[[ Help bindings
    map('n', '<Plug>(leader-help-map)b', tb.keymaps,   { desc = 'Search key[b]indings' })
    map('n', '<Plug>(leader-help-map)h', tb.help_tags, { desc = 'Search help [t]ags' })
    --]]

    ---[[ Search bindings
    map('n', '<Plug>(leader-search-map)b', tb.current_buffer_fuzzy_find, { desc = '[S]earch current [b]uffer]' })
    map('n', '<Plug>(leader-search-map)d', tb.diagnostics,               { desc = '[S]earch [d]iagnostics'     })
    map('n', '<Plug>(leader-search-map)g', tb.live_grep,                 { desc = '[S]earch by [g]rep'         })
    map('n', '<Plug>(leader-search-map)j', tb.jumplist,                  { desc = '[S]earch [j]umps'           })
    map('n', '<Plug>(leader-search-map)l', tb.loclist,                   { desc = '[S]earch [l]ocation-list'   })
    map('n', '<Plug>(leader-search-map)m', tb.marks,                     { desc = '[S]earch [m]arks'           })
    map('n', '<Plug>(leader-search-map)q', tb.quickfix,                  { desc = '[S]earch [q]uickfix'        })
    map('n', '<Plug>(leader-search-map)r', tb.registers,                 { desc = '[S]earch [r]egisters'       })
    map('n', '<Plug>(leader-search-map)s', tb.symbols,                   { desc = '[S]earch [s]ymbols'         })
    map('n', '<Plug>(leader-search-map)t', tb.tags,                      { desc = '[S]earch [t]ags'            })
    map('n', '<Plug>(leader-search-map)w', tb.grep_string,               { desc = '[S]earch current [w]ord'    })
    --]]

    ---[[ VCS bindings
    map('n', '<Plug>(leader-vcs-map)f', tb.git_files,    { desc = 'Open [V]cs [F]ile'   })
    map('n', '<Plug>(leader-vcs-map)H', tb.git_commits,  { desc = 'Show [V]cs [S]tatus' })
    map('n', '<Plug>(leader-vcs-map)h', tb.git_bcommits, { desc = 'Show [V]cs [S]tatus' })
    map('n', '<Plug>(leader-vcs-map)s', tb.git_status,   { desc = 'Show [V]cs [S]tatus' })
    --]]
  end,
}

-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
require('packer').use {
  'nvim-telescope/telescope-fzf-native.nvim',
  cond = '(vim.fn.empty(vim.g.vscode) == 1) and (vim.fn.executable "make" == 1)',
  run = 'make',
}

require('packer').use {
  'nvim-lua/plenary.nvim',
  opt = true,
}
