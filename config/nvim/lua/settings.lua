vim.opt.guicursor = "a:block"
vim.opt.incsearch = true
vim.opt.number = true;
vim.opt.relativenumber = true;
vim.opt.smartindent = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.showmode = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.textwidth = 100
vim.opt.colorcolumn = "+20"
vim.opt.smartcase = true
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.history = 1000
vim.opt.cmdheight = 1
vim.opt.hlsearch = false
vim.opt.foldenable = false
vim.opt.laststatus = 2
vim.opt.ttimeoutlen = 50

vim.g.indent_guides_enable_on_vim_startup = 0
vim.g.indent_guides_start_level = 2
vim.g.indent_guides_guide_size = 1

vim.g.airline_theme = "cool"
vim.g.airline_powerline_fonts = 1
-- vim.g.airline_theme= "airlinje"

-- vim.opt.wildmode = "longest,list,full"
-- vim.opt.wildmenu = true
-- vim.opt.compatible = false
-- vim.opt.backspace = "indent,eol,start"
-- vim.opt.mouse = "a"
-- vim.opt.completeopt = "menuone,menu,longest"
-- vim.opt.wildignore+ = *\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
-- vim.opt.completeopt += "longest"
-- vim.opt.termguicolors = true

-- vim.opt.undodir = "~/.vimundo"
-- vim.opt.viewdir = "~/.vimviews"
-- vim.opt.directory = "~/.vimswap"

vim.g.copilot_filetypes = {
       [ "*" ] = false,
       fsharp = true,
       fortran = true,
       html = true,
       nix = true,
       css = true,
       yaml = true,
       json = true,
       js = true,
       ts = true,
       lua = true,
       python = true,
       julia = true,
       rust = true,
   }
