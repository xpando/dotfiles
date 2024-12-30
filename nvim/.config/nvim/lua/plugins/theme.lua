return {
   {
         "folke/tokyonight.nvim",
       lazy = false,
     priority = 1000,
     config = function()
             vim.cmd.colorscheme 'tokyonight-night'
         end,
     }
}

-- return {
--  {
--      'catppuccin/nvim',
--      priority = 1000,
--
--      config = function()
--          require('catppuccin').setup {
--              flavour = 'mocha',
--              transparent_background = true
--          }                                                                                                                  --          vim.cmd.colorscheme 'catppuccin'
--      end,
--  },
--}

