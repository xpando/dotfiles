return {
  'navarasu/onedark.nvim',
  priority = 1000,

  config = function()
    require('onedark').setup {
      style = 'dark',

			transparent = false,

			colors = {
       bg0 = '#1f1f1f',
      },

      lualine = {
        transparent = false,
      },

      diagnostics = {
        darker = true,
        undercurl = true,
        background = true,
      },
    }

    vim.cmd.colorscheme 'onedark'
  end,
}
