local PKGS = {
    'savq/paq-nvim'; -- Let Paq manage itself
  
    'navarasu/onedark.nvim';        -- OneDark theme
    'nvim-lualine/lualine.nvim';
    'nvim-lua/popup.nvim';          -- An implementation of the Popup API from vim in Neovim
    'nvim-lua/plenary.nvim';        -- Useful lua functions used ny lots of plugins
    'folke/which-key.nvim';         -- WhichKey.nvim is a vim plugin that shows a list of keybindings in a popup window  
    'kyazdani42/nvim-tree.lua';     -- Tree view for files and directories
    'akinsho/bufferline.nvim';      -- A buffer line plugin for Neovim
    'kyazdani42/nvim-web-devicons';
  
    -- LSP
    'neovim/nvim-lspconfig';           -- enable LSP
    'williamboman/nvim-lsp-installer'; -- simple to use language server installer
  
    -- Completions
    'hrsh7th/nvim-cmp';         -- The completion plugin
    'hrsh7th/cmp-buffer';       -- buffer completions
    'hrsh7th/cmp-path';         -- path completions
    'hrsh7th/cmp-cmdline';      -- cmdline completions
    'saadparwaiz1/cmp_luasnip'; -- snippet completions
    'hrsh7th/cmp-nvim-lsp';
  
    -- Telescope
    'nvim-telescope/telescope.nvim';
  
    -- Treesitter
    'nvim-treesitter/nvim-treesitter';
  
    -- Git
    'lewis6991/gitsigns.nvim';
  }
  
  local function clone_paq()
    local path = vim.fn.stdpath 'data' .. '/site/pack/paqs/start/paq-nvim'
    if vim.fn.empty(vim.fn.glob(path)) > 0 then
        vim.fn.system {
            'git',
            'clone',
            '--depth=1',
            'https://github.com/savq/paq-nvim.git',
            path,
        }
    end
  end
  
  local function bootstrap()
    clone_paq()
  
    -- Load Paq
    vim.cmd 'packadd paq-nvim'
    local paq = require 'paq'
  
    -- Exit nvim after installing plugins
    vim.cmd 'autocmd User PaqDoneInstall quit'
  
    -- Read and install packages
    paq(PKGS):install()
  end
  
  local function sync_all()
    -- package.loaded.paq = nil
    (require 'paq')(PKGS):sync()
  end
  
  return { bootstrap = bootstrap, sync_all = sync_all }