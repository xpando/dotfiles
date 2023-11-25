-- Automatically download and initialize the Lazy plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--single-branch',
    '--branch=stable',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup(
  {
    { import = 'xpando.plugins' },
    { import = 'xpando.plugins.lsp' },
  },
  {
    install = {
      -- intall missing plugins on startup
      missing = true,
      -- try to load one of these colorschemes when starting an installation during startup
      colorscheme = { 'onedark' },
    },

    checker = {
      -- automatically check for plugin updates
      enabled = false,
      notify = false,
    },

    change_detection = {
      -- automatically check for config file changes and reload the ui
      enabled = true,
      notify = false, 
    },
  }
)
