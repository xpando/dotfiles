syntax enable
filetype on
filetype plugin on
filetype indent on
set nocompatible " always gimmie the modern stuff
set hidden
set cursorline
set noshowmode " lightline shows the mode in the status line
set nobackup
set nowritebackup
set updatetime=300
set path+=** " Recursive search
set ts=2
set shiftwidth=2
set ai sw=2
set expandtab
set hlsearch
set sidescroll=6
set splitright
set splitbelow

" Remap leader to spacebar
nnoremap <Space> <Nop>
let mapleader="\<Space>"
nnoremap <silent> <leader>ec :e `chezmoi source-path`/dot_config/nvim/init.vim<CR>
nnoremap <silent> <leader>sc :source $MYVIMRC
nnoremap <silent> <leader>ac :!chezmoi apply<CR>
nnoremap <silent> <C-Space> :NERDTreeToggle<CR>

nnoremap <silent> <leader>fo :Files<CR>


" True color
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set t_Co=256
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
" transparent background
au ColorScheme * hi Normal ctermbg=none guibg=none

" Plugins
call plug#begin()

" GUI enhancements
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
" Plug 'andymass/vim-matchup'

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Code completion
"Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Git
Plug 'tpope/vim-fugitive'

" Language server support
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

call plug#end()

" Color scheme
colorscheme onehalfdark 
let g:lightline = {
  \ 'colorscheme': 'onehalfdark',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead'
  \ }
  \ }

