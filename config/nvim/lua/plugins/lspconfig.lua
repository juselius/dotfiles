return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostic = {
        virtual_text = false,
        underline = true,
      },
      inlay_hints = { enabled = false, },
    },
  },
}
