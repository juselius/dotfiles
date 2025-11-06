-- F#
vim.opt_local.textwidth = 120;
vim.opt_local.colorcolumn = "+1";
vim.opt_local.expandtab = true
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

vim.opt_local.signcolumn = "yes"
vim.opt_local.number = true
vim.opt_local.relativenumber = true
vim.opt_local.comments = { "://", ":///", "s1:(*,mb:*,ex:*)" }
vim.opt_local.commentstring = "// %s"

vim.lsp.enable("fsautocomplete")
