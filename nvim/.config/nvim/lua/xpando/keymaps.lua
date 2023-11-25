local km = vim.keymap

-- Plugin manager (Lazy)
km.set('n', '<leader>L',  '<cmd>:Lazy<CR>',        { desc = 'Show plugin manager UI' })
km.set('n', '<leader>lu', '<cmd>:Lazy update<CR>', { desc = 'Update plugins' })
km.set('n', '<leader>lc', '<cmd>:Lazy clean<CR>',  { desc = 'Remove no longer used plugins' })

-- LSP manager (Mason)
km.set('n', '<leader>M',  '<cmd>:Mason<CR>',                            { desc = 'Show LSP manager UI' })
km.set('n', '<leader>mu', '<cmd>:MasonUpdate<CR>:MasonToolsUpdate<CR>', { desc = 'Update LSP tools' })

-- Telescope - search all the things
km.set('n', '<leader>sc', '<cmd>:Telescope commands<CR>',    { desc = 'Search plugin commands' })
km.set('n', '<leader>sd', '<cmd>:Telescope diagnostics<CR>', { desc = 'Search diagnostics' })
km.set('n', '<leader>sf', '<cmd>:Telescope find_files<CR>',  { desc = 'Search for file by name' })
km.set('n', '<leader>sg', '<cmd>:Telescope live_grep<CR>',   { desc = 'Search file contents with grep' })
km.set('n', '<leader>sh', '<cmd>:Telescope help_tags<CR>',   { desc = 'Search neovim help' })
km.set('n', '<leader>sn', '<cmd>:NoiceTelescope<CR>',        { desc = 'Search notifications' })

-- Diagnostics
km.set('n', '[d', vim.diagnostic.goto_prev,         { desc = 'Go to previous diagnostic message' })
km.set('n', ']d', vim.diagnostic.goto_next,         { desc = 'Go to next diagnostic message' })
km.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
km.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Linting and Formatting
km.set('n', '<leader>cf', '<cmd>:Format<CR>', { desc = 'Format code' })

-- Neotest
km.set('n', '<leader>tjn', '<cmd>Neotest jump next<CR>',    { desc = 'Jump to next test' })
km.set('n', '<leader>tjp', '<cmd>Neotest jump prev<CR>',    { desc = 'Jump to previous test' })
km.set('n', '<leader>to',  '<cmd>Neotest output-panel<CR>', { desc = 'Show test output panel' })
km.set('n', '<leader>trl', '<cmd>Neotest run last<CR>',     { desc = 'Re-run last test' })
km.set('n', '<leader>trn', '<cmd>Neotest run<CR>',          { desc = 'Run the nearest test' })
km.set('n', '<leader>ts',  '<cmd>Neotest summary<CR>',      { desc = 'Show test summary' })

-- Debugging
local dapui = require('dapui')
km.set('n', '<leader>d', dapui.toggle, { desc = 'Toggle debugger UI' })