if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

Plug 'tpope/vim-fugitive' " Git integration
" Plug 'tpope/vim-rhubarb' " Github integration for fugitive

if has("nvim")
  Plug 'joshdick/onedark.vim'
  Plug 'hoob3rt/lualine.nvim'
  
  Plug 'nvim-lua/plenary.nvim' " lua modules required for telescope
  Plug 'nvim-telescope/telescope.nvim' " Fuzzy finder

  " File browser
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'kristijanhusak/defx-git'
  Plug 'kristijanhusak/defx-icons'
  Plug 'kyazdani42/nvim-web-devicons'
 
  " Better syntax highlighting
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

  " A collection of common configurations for Neovim's built-in language server client
  Plug 'neovim/nvim-lspconfig'

  " Automatically creates missing LSP diagnostics highlight groups 
  " for color schemes that don't yet support the Neovim 0.5 
  " builtin lsp client.
  Plug 'folke/lsp-colors.nvim'
  
  " Plug 'glepnir/lspsaga.nvim'

  " async completions for Neovim 0.5 built in lsp client
  Plug 'nvim-lua/completion-nvim'

  " Plug 'nvim-lua/popup.nvim'
  " Plug 'windwp/nvim-autopairs'

endif

call plug#end()

