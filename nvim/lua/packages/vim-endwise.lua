require('packer').use { -- Add 'end' structures automatically
  'tpope/vim-endwise',
  cond = 'vim.fn.empty(vim.g.vscode) == 1',
}
