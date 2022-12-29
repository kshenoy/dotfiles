require('packer').use { -- "gc" to comment visual regions/lines
  'numToStr/Comment.nvim',

  config = function()
    require('Comment').setup()
  end,
}
