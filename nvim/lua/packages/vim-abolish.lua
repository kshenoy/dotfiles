require('packer').use { -- Smarter abbrev, substitutes and case-coercions
  'tpope/vim-abolish',
  cond = 'vim.fn.empty(vim.g.vscode) == 1',
}
