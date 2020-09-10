let $NVIM_TUI_ENABLE_TRUE_COLOR=1

colorscheme onehalfdark

" Lightline
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

" transparent background
" au ColorScheme * hi Normal ctermbg=none guibg=none
au vimenter * hi Normal ctermbg=none guibg=none