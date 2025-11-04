return {
  "mbbill/undotree",
  config = function()
    vim.keymap.set('n', '<leader>gu', vim.cmd.UndotreeToggle)
  end
}
