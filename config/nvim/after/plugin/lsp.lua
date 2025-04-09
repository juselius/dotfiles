-- My lsp configs...
vim.g.lsp_zero_extend_lspconfig = 0

local lspconfig = require("lspconfig")
local lsp_zero = require("lsp-zero")
local cmp = require("cmp")
local cmp_action = lsp_zero.cmp_action()

local cmp_select = {behavior = cmp.SelectBehavior.Select}

-- NOTE: Ignore the extend_lspconfig error on startup
vim.g.lsp_zero_extend_lspconfig = 0

-- Se `:h cmp` for flere valg
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Up>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<Down>'] = cmp.mapping.select_next_item(cmp_select),
  }),
})

lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

lsp_zero.setup_servers({
    'cssls',
    'gopls',
    'ionide',
    'marksman',
    'nil_ls',
    'ts_ls',
    'pyright',
    -- 'clangd',
    -- 'dhall_lsp_server',
})

local lua_opts = lsp_zero.nvim_lua_ls()
lspconfig.lua_ls.setup(lua_opts)

lsp_zero.setup()
