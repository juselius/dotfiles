return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  config = function(_, opts)
    Snacks.indent.disable()
  end,
  -- keys = {
  --   {
  --     "<leader>ii",
  --     function()
  --       if Snacks.indent.enabled then
  --         Snacks.indent.disable()
  --       else
  --         Snacks.indent.enable()
  --       end
  --     end,
  --     desc = "Toggle Snacks Indent",
  --   }
  -- }
}
