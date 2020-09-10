filetype on
filetype plugin on
filetype indent on

set iskeyword+=-        " treat dash separated words as a word text object
set formatoptions-=cro  " stop newline continuation of comments

syntax enable
set hidden
set nowrap
set encoding=utf-8
set fileencoding=utf-8
set ruler               " show the cursor position all the time
set cmdheight=2         " more space for displaying messages
set splitbelow          " horizontal splits will always be below
set splitright          " vertical splits will always be to the right
set t_Co=256            " support 256 colors
set conceallevel=0      " so that I can see `` in markdown files
set tabstop=2           " insert 2 spaces for a tab
set shiftwidth=2        " 2 spaces for indentation
set smarttab
set expandtab           " convert tabs to spaces
set smartindent
set autoindent
set laststatus=2        " always display the status line
set number              " display line numbers
set relativenumber      " use relative line numbering
set cursorline          " enable highlighting the current line
" set background=dark
set noshowmode          " mode is displayed with lightline
set nobackup            " recommended by coc
set nowritebackup       " recommended by coc
set signcolumn=yes      " always show the sign column, otherwise it would shift the text each time
set updatetime=300      " faster completion
set timeoutlen=100
set clipboard=unnamedplus " copy/paste between vim and everything else
set incsearch
set path+=**            " recusive search

" writing to files that require sudo
cmap w!! w !sudo tee %
