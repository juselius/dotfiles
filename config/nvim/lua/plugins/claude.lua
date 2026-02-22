return {
  'greggh/claude-code.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' }, -- Dependency for git operations
  config = function()
    require('claude-code').setup({
      -- Optional configuration here
      window = {
        width = 0.8,  -- 80% of editor width
        height = 0.8, -- 80% of editor height
      },
      -- Add keymaps as desired, e.g.:
      mappings = {
        toggle = '<leader>cc',
      },
    })
  end,
}
