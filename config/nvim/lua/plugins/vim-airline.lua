return {
  "vim-airline/vim-airline",
  enabled = true,
  lazy = false,
  priority = 1000,
  dependencies = {
    "vim-airline/vim-airline-themes",
  },
  init = function()
    vim.g.airline_theme = "cool"
    vim.g.airline_powerline_fonts = 1
  end
}
