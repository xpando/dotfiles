local nnoremap = require('xpando.utils').nnoremap

-- Open file
nnoremap('<leader>o', '<cmd>Ex<CR>')

-- Telescope - files and buffers
-- nnoremap('<leader>ff', '<cmd>Telescope find_files<CR>')
-- nnoremap('<leader>fg', '<cmd>Telescope live_grep<CR>')
-- nnoremap('<leader>fb', '<cmd>Telescope buffers<CR>')
-- -- Telescope - Git
-- nnoremap('<leader>gs', '<cmd>Telescope git_status<CR>')
-- nnoremap('<leader>gc', '<cmd>Telescope git_commits<CR>')
-- nnoremap('<leader>gb', '<cmd>Telescope git_branches<CR>')

-- Sync plugins
nnoremap('<leader>ps', function()
    package.loaded.plugins = nil
    require('xpando.plugins').sync_all()
end)

-- Edit plugins
nnoremap('<leader>pe', function()
    local src_path = vim.fn.stdpath('config') .. '/lua/xpando/plugins.lua'
    vim.cmd('edit' .. src_path)
end)

-- Clean plugins
nnoremap('<leader>pc', function()
    package.loaded.plugins = nil
    require('paq').clean()
end)
