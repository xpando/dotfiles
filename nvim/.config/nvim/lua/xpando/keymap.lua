local nnoremap = require('xpando.utils').nnoremap

-- Open file
nnoremap('<leader>o', '<cmd>Ex<CR>')

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
