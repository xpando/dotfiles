return {
  -- Test runners
  'marilari88/neotest-vitest',
  -- 'haydenmeade/neotest-jest',
  {
    'nvim-neotest/neotest',
    config = function()
      require('neotest').setup {
        adapters = {
          require('neotest-vitest'),
          -- require('neotest-jest'),
        },
      }
    end,
  },
}