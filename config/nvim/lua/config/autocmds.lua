-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- autocmd({ "BufWritePre" }, {
--     pattern = {"*"},
--     callback = function(_)
--         local save_cursor = vim.fn.getpos(".")
--         vim.cmd([[%s/\s\+$//e]])
--         vim.fn.setpos(".", save_cursor)
--     end
-- })
--
--
-- autocmd("TextYankPost", {
-- 	group = augroup("HighlightYank", {}),
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.highlight.on_yank({
-- 			higroup = "IncSearch",
-- 			timeout = 40,
-- 		})
-- 	end
-- })
--
autocmd('LspAttach', {
  group = augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    print("Attaching", client.name, "LSP")

    vim.opt.completeopt = { "menuone", "popup", "noselect" }
    vim.lsp.completion.enable(true, client.id, args.buf, {
      autotrigger = true,
      convert = function(item)
        return { abbr = item.label:gsub('%b()', '') }
      end,
    })

    if client:supports_method('textDocument/definition') then
      -- Create a keymap for vim.lsp.buf.definition ...
      vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end)
    end
    if client:supports_method('textDocument/inlayHint') then
      -- Create a keymap for vim.lsp.buf.definition ...
      vim.keymap.set('n', 'gih', function()
        local enabled = vim.lsp.inlay_hint.is_enabled()
        vim.lsp.inlay_hint.enable(not enabled)
      end)
    end

    vim.keymap.set('n', 'gh', function() vim.diagnostic.open_float() end)
    vim.diagnostic.config({ virtual_text = false })
  end,
})
