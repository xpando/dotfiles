return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',

  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },

  config = function()
    local telescope = require 'telescope'
    local actions   = require 'telescope.actions'

    telescope.setup {
      defaults = {
        path_display = { 'truncate' },
        mappings = {
          i = {
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-q>'] = actions.send_selected_to_qflist,
          },
        },
      },
    }

    -- Enable telescope fzf native, if installed
    telescope.load_extension('fzf')
  end,
}