-- Add indentation guides even on blank lines
require('packer').use {
  'lukas-reineke/indent-blankline.nvim',
  cond = 'vim.fn.empty(vim.g.vscode) == 1',

  config = function()
    require('indent_blankline').setup {
      char = '┊',
      show_trailing_blankline_indent = false,
    }

    vim.keymap.set('n', '<Plug>(leader-toggle-map)i', '<Cmd>IndentBlanklineToggle!',
      { desc = "Toggle indent blankline" })
  end,
}
