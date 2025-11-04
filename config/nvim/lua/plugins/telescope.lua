return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    local actions = require('telescope.actions')
    -- vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Telescope git files" })
    -- vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Telescope find files" })
    -- vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Telescope buffers" })
    vim.keymap.set("n", "<C-p>", builtin.git_files, {})
    vim.keymap.set("n", "<C-l>", builtin.find_files, {})
    vim.keymap.set("n", "<leader>f", builtin.find_files, {})
    vim.keymap.set("n", "<leader>g", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>b", builtin.buffers, {})

    telescope.setup(
        {
            defaults = {
                mappings = {
                    i = {
                        ["<esc>"] = actions.close,
                    },
                },
            },
        }
    )
  end,
}
