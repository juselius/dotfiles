local telescope = require('telescope')
local builtin = require('telescope.builtin')
local actions = require('telescope.actions')

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

vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<C-l>", builtin.find_files, {})
vim.keymap.set("n", "<leader>f", builtin.find_files, {})
vim.keymap.set("n", "<leader>g", builtin.live_grep, {})
vim.keymap.set("n", "<leader>b", builtin.buffers, {})

