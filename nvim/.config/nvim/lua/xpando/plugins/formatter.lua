return {
  {
    'mhartington/formatter.nvim',
    config = function()
      require('formatter').setup {
        filetype = {
          typescript = { require("formatter.filetypes.typescript").prettierd },
          typescriptreact = { require("formatter.filetypes.typescriptreact").prettierd },
        },
      }
    end,
  },
}