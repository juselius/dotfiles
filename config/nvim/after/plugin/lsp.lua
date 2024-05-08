-- My lsp configs...
vim.g.lsp_zero_extend_lspconfig = 0

local lsp_zero = require("lsp-zero")
-- lsp_zero.extend_lspconfig()

local cmp = require'cmp'
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp_zero.defaults.cmp_mappings({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
})

-- cmp_mappings['<Tab>'] = nil
-- cmp_mappings['<S-Tab>'] = nil
-- cmp_mappings['<CR>'] = nil

lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

lsp_zero.setup_servers({
    'cssls',
    'gopls',
    'ionide',
    'marksman',
    'nil_ls',
    'tsserver',
    'pyright',
    -- 'clangd',
    -- 'dhall_lsp_server',
})

local lua_opts = lsp_zero.nvim_lua_ls()
require('lspconfig').lua_ls.setup(lua_opts)

lsp_zero.setup()
