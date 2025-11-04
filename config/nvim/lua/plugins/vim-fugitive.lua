return {
  "tpope/vim-fugitive",
  config = function()
    vim.keymap.set('n', '<leader>gs', ':G<cr>')
  end
}
