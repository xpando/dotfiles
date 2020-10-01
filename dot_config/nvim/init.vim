" General Settings
source $HOME/.config/nvim/vim-plug/plugins.vim
source $HOME/.config/nvim/general/settings.vim

" Theme
source $HOME/.config/nvim/themes/settings.vim

if has("persistent_undo")
    set undodir=$HOME/.cache/nvim_undo
    set undofile
endif

" Key bindings
source $HOME/.config/nvim/keys/mappings.vim

" lua require'nvim_lsp'.tsserver.setup{ }
