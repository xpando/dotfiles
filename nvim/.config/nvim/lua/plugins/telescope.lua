local kmap = vim.keymap.set

return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      require('telescope').setup {
        pickers = {
          find_files = {
            theme = 'ivy'
          },
        },
      }

      local ts = require('telescope.builtin')
      kmap('n', '<leader>fh', ts.help_tags, {})
      kmap('n', '<leader>ff', ts.find_files, {})
      kmap('n', '<leader>fg', ts.live_grep, {})
      kmap('n', '<leader>fb', ts.buffers, {})
      kmap('n', '<leader>fc', function() ts.find_files({ cwd = vim.fn.stdpath('config') }) end, {})
    end,
  },

  -- {
  --   'nvim-telescope/telescope-ui-select.nvim',

  --   config = function()
  --     require('telescope').setup {
  --       extensions = {
  --         ['ui-select'] = {
  --           require('telescope.themes').get_dropdown {},
  --         },
  --       },
  --     }

  --     -- To get ui-select loaded and working with telescope, you need to call
  --     -- load_extension, somewhere after setup function:
  --     require('telescope').load_extension 'ui-select'
  --   end,
  -- },
}
