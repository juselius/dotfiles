return {
  "github/copilot.vim",
  config = function()
    vim.g.copilot_filetypes = {
       [ "*" ] = false,
       fsharp = true,
       fortran = true,
       html = true,
       js = true,
       ts = true,
       lua = true,
       python = true,
       julia = true,
       rust = true,
   }
  end
}
