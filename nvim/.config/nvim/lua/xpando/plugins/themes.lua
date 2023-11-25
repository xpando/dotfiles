return {

  {
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      require('onedark').setup {
        style = 'dark',
        -- transparent = true,
        colors = {
          bg0 = '#1f1f1f',
        },
        diagnostics = {
          darker = true,
          undercurl = true,
          background = true,
        },
      }
      vim.cmd.colorscheme 'onedark'
    end,
  },


}