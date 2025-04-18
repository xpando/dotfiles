return {
  'nvim-neotest/neotest',

  dependencies = {
		'nvim-neotest/nvim-nio',
		'nvim-neotest/neotest-python',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'antoinemadec/FixCursorHold.nvim',
  },

  config = function()
    require('neotest').setup {
      adapters = {
        require('neotest-python')({
          -- Extra arguments for nvim-dap configuration
          -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
          dap = { justMyCode = false },
          -- Command line arguments for runner
          -- Can also be a function to return dynamic values
          args = {"--log-level", "DEBUG"},
          -- Runner to use. Will use pytest if available by default.
          -- Can be a function to return dynamic value.
          runner = "pytest",
          -- Custom python path for the runner.
          -- Can be a string or a list of strings.
          -- Can also be a function to return dynamic value.
          -- If not provided, the path will be inferred by checking for 
          -- virtual envs in the local directory and for Pipenev/Poetry configs
          python = ".venv/bin/python",
          -- Returns if a given file path is a test file.
          -- NB: This function is called a lot so don't perform any heavy tasks within it.
          is_test_file = function(file_path)
            local path = file_path:match("/test_.*.py$")
            if path then
              return true
            else
              return false
            end
          end,
        }),
      },
    }
  end,
}
