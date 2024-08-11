local map = vim.keymap.set

map('n', '<leader>l', ':Lazy<CR>', {})
map('n', '<leader>m', ':Mason<CR>', {})

-- Neotree
map('n', '<C-e>', ':Neotree filesystem reveal left toggle<CR>', {})

-- Buffers
map('n', '<C-w>', ':bd<CR>', {})
map('n', '<Tab>', ':bnext<CR>', {})
map('n', '<S-Tab>', ':bprev<CR>', {})

-- Telescope
local ts = require 'telescope.builtin'
map('n', '<leader>fc', function() ts.find_files({ cwd = '~/.config/nvim' }) end, {})
map('n', '<leader>ff', ts.find_files, {})
map('n', '<leader>fg', ts.live_grep, {})
map('n', '<leader>fb', ts.buffers, {})

map('n', 'K', vim.lsp.buf.hover, {})
map('n', 'gD', vim.lsp.buf.declaration, {})
map('n', 'gd', vim.lsp.buf.definition, {})
map('n', '<leader>ba', vim.lsp.buf.code_action, {})
map('n', '<leader>bf', vim.lsp.buf.format, {})

-- Neotest
local nt = require 'neotest'
map('n', '<leader>tr', nt.run.run, {})
map('n', '<leader>td', function() nt.run.run({ strategy = 'dap', suite = true }) end, {})
map('n', '<leader>tf', function() nt.run.run(vim.fn.expand("%")) end, {})
map('n', '<leader>ts', nt.summary.toggle, {})
