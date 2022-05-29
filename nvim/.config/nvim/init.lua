-- Boostrap with: nvim --headless -u NONE -c 'lua require("plugins").bootstrap()'
setmetatable(_G, { __index = vim })
cmd 'runtime vimrc'

local _utils  = require 'utils'
local command = _utils.command
local keymap  = _utils.keymap
local augroup = _utils.augroup

do -- Paq
    keymap('<leader>pq', function()
        package.loaded.plugins = nil
        require('plugins').sync_all()
    end)
end

do -- git signs: https://github.com/lewis6991/gitsigns.nvim
    require('gitsigns').setup()
end

do -- lua line: https://github.com/nvim-lualine/lualine.nvim
    require('lualine').setup {
        options = {
            component_separators = { left = '|', right = '|'},
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {'filename'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {},
            lualine_z = {'location'}
        }
    }
end

do -- Tree-sitter
    opt.foldmethod = 'expr'
    opt.foldexpr = 'nvim_treesitter#foldexpr()'
    require('nvim-treesitter.configs').setup {
        ensure_installed = { 'javascript', 'lua', 'python', 'rust', 'html', 'query', 'toml' },
        highlight = { enable = true },
        indent = { enable = true },
    }
end

do -- lsp
    require('nvim-lsp-installer').setup {
        automatic_installation = true,
        ui = {
            icons = {
                server_installed = "✓",
                server_pending = "➜",
                server_uninstalled = "✗"
            }
        }
    }
end