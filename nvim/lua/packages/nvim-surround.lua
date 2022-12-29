require('packer').use {
  'kylechui/nvim-surround',

  config = function()
    require('nvim-surround').setup {
      keymaps = {
        normal = "gs",
        normal_cur = "gss",
        normal_line = "gS",
        normal_cur_line = "gSS",
        visual = "gs",
        visual_line = "gS",
      }
    }
  end,
}
