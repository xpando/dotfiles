-- Neovide options
if vim.g.neovide then
  vim.o.guifont = 'IosevkaTerm NFP Light:h16'
  vim.g.neovide_underline_automatic_scaling = true
  vim.g.neovide_cursor_animation_length = 0
  vim.keymap.set('n', '<C-=>', '<cmd>let g:neovide_scale_factor = g:neovide_scale_factor + 0.05<CR>', { silent = true })
  vim.keymap.set('n', '<C-->', '<cmd>let g:neovide_scale_factor = g:neovide_scale_factor - 0.05<CR>', { silent = true })
end
