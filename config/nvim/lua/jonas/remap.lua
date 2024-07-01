vim.g.mapleader = " "

vim.keymap.set("n", "<C-n>", vim.cmd.Ex)

vim.keymap.set("n", "<leader>gp", ":diffput<CR>")
vim.keymap.set("n", "<leader>gg", ":diffget<CR>")
vim.keymap.set("n", "<leader>gt", ":diffget //2<CR>")
vim.keymap.set("n", "<leader>gn", ":diffget //3<CR>")

vim.keymap.set("n", "<F6>", ":setlocal spell! spelllang=en_us<CR>")
vim.keymap.set("n", "<F7>", ":setlocal spell! spelllang=nb<CR>")

vim.keymap.set({ 'n', 'i', 'v' }, "<C-.>", "@:", { remap = false })
vim.keymap.set({ 'n', 'i', 'v' }, "<C-C>", '"+y', { remap = false })
vim.keymap.set({ 'n', 'i', 'v' }, "<C-B>", '"+p', { remap = false })
-- vim.keymap.set('v', "<C-N>", ":normal.<CR>", { remap = false })
vim.keymap.set({ 'n', 'i', 'v' }, "<silent> <C-S>", ":update<CR>", { remap = false })
vim.keymap.set('v', "<silent> <C-S>", "<C-C>:update<CR>", { remap = false })
vim.keymap.set('i', "<silent> <C-S>", "<C-O>:update<CR>", { remap = false })

 -- zap the damned Ex mode.
vim.keymap.set('n', "Q", "<nop>", { remap = false })

vim.keymap.set({ 'n', 'i', 'v' }, "<C-L>", ":noh<cr>")
vim.keymap.set({ 'n', 'i', 'v' }, "x", "<Plug>Commentary<space>")
vim.keymap.set({ 'n', 'i', 'v' }, "<C-/>", "<Plug>Commentary<space>")
vim.keymap.set('n', "s", "<Plug>Sneak_s")
vim.keymap.set('v', "s", "<Plug>Sneak_s")
vim.keymap.set({ 'n', 'i', 'v' }, "<S-UP>", "<UP>")
vim.keymap.set({ 'n', 'i', 'v' }, "<S-DOWN>", "<DOWN>")
vim.keymap.set({ 'n', 'i', 'v' }, "<S-TAB>", ":tabnext<nl>")
vim.keymap.set('n', "<F1>", "<nop>")
vim.keymap.set({ 'n', 'i', 'v' }, "<F1>", "<ESC>")
vim.keymap.set('i', "<F1>", "<ESC>")
