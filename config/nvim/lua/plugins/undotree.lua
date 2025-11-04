return {
  "mbbill/undotree",
  enabled = false,
  config = function()
    vim.keymap.set('n', '<leader>gu', vim.cmd.UndotreeToggle)
  end
}
