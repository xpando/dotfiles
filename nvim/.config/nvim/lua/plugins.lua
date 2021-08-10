require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Color schemes
  --use 'tomasr/molokai'
  use 'joshdick/onedark.vim'

  -- Fancier statusline
  use 'itchyny/lightline.vim'

  -- Fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'}, 
      {'nvim-lua/plenary.nvim'}
    }
  }

  -- Git commands in nvim
  use 'tpope/vim-fugitive' 

  -- LSP and completion
  use { 'neovim/nvim-lspconfig' }
  use { 'nvim-lua/completion-nvim' }

  -- Add indentation guides even on blank lines
  --use 'lukas-reineke/indent-blankline.nvim'

  -- Add git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }

  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use 'nvim-treesitter/nvim-treesitter'

  -- use {
  --   'AckslD/nvim-whichkey-setup.lua',
  --   requires = {'liuchengxu/vim-which-key'},
  -- }
  -- use 'nvim-treesitter/nvim-treesitter'
end)
