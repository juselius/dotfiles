" == basic ==
syntax on
filetype plugin indent on

set backspace=indent,eol,start
set nocompatible
set number
set nowrap
set showmode
set tabstop=4
set shiftwidth=4
set softtabstop=4
set textwidth=100
set colorcolumn=120
set smartcase
set smarttab
set smartindent
set autoindent
set expandtab
set undofile
set undolevels=1000
set undoreload=10000
set history=1000
set mouse=a
set completeopt=menuone,menu,longest
set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
set wildmode=longest,list,full
set wildmenu
set completeopt+=longest
set cmdheight=1
set nohlsearch
set nofoldenable
set termguicolors


set undodir=~/.vimundo
set viewdir=~/.vimviews
set directory=~/.vimswap

if !has('nvim')
  set clipboard=unnamedplus,autoselect
endif

function! StripTrailingWhitespace()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business:
  %s/\s\+$//e
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

set shell=/bin/sh "fix for fish

noremap <C-.> @:
noremap <C-C> "+y
noremap <C-B> "+p
vnoremap <C-N> :normal.<CR>
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>


" zap the damned Ex mode.
nnoremap Q <nop>

colorscheme NeoSolarized
set background=dark
let g:neosolarized_contrast = "high"
let g:neosolarized_visibility = "normal"

" highlight MatchParen ctermbg=lightblue ctermfg=grey guibg=lightblue guifg=grey
highlight MatchParen  cterm=underline gui=underline guibg=none guifg=none

" airline
let g:airline_theme="cool"
"let g:airline_theme="airlinje"
set laststatus=2
set ttimeoutlen=50


" == ghc-mod ==

map <silent> tw :GhcModTypeInsert<CR>
map <silent> ts :GhcModSplitFunCase<CR>
map <silent> tq :GhcModType<CR>
map <silent> te :GhcModTypeClear<CR>

" == supertab ==

let g:SuperTabDefaultCompletionType = '<c-x><c-o>'

if has("gui_running")
  imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
else " no gui
  if has("unix")
    inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
  endif
endif

" == neco-ghc ==

let g:haskellmode_completion_ghc = 1
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

" == nerd-tree ==

map <Leader>n :NERDTreeToggle<CR>

" == tabular ==

let g:haskell_tabular = 1

vmap a= :Tabularize /=<CR>
vmap a; :Tabularize /::<CR>
vmap a- :Tabularize /-><CR>
vmap a, :Tabularize /<-<CR>
vmap al :Tabularize /[\[\\|,]<CR>

" == ctrl-p ==

map <silent> <Leader>t :CtrlP()<CR>
noremap <leader>b<space> :CtrlPBuffer<cr>
let g:ctrlp_custom_ignore = '\v[\/]dist$'

map <C-L> :noh<cr>
map x <Plug>Commentary<space>
map <C-_> <Plug>Commentary<space>
nmap s <Plug>Sneak_s
vmap s <Plug>Sneak_s
map <S-UP> <UP>
map <S-DOWN> <DOWN>
map <S-TAB> :tabnext<nl>
"nmap <Leader>n :NumbersToggle<cr>

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

autocmd FileType fsharp setl commentstring=//%s

" fortran
let fortran_do_enddo = 1
let fortran_more_precise = 1
let fortran_have_tabs = 1
"
" indent_guides
let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
"

" Strip whitespace {
function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
" }

autocmd FileType * autocmd BufWritePre <buffer> call StripTrailingWhitespace()
" autocmd VimEnter * NoMatchParen

set updatetime=1500
" let g:snipMate = { 'snippet_version' : 1 }

"
" nvim-cmp: completions
"
function! s:nvim_cmp()
lua << EOF
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<Enter>']     = cmp.mapping.confirm({ select = true }),
      ['<C-u>']     = cmp.mapping.scroll_docs(-4),
      ['<C-d>']     = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
      }, {
        { name = 'path' },
        { name = 'buffer' },
      })
  })

  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- cmp.setup.cmdline(':', {
  --   mapping = cmp.mapping.preset.cmdline(),
  --   sources = cmp.config.sources({
  --     { name = 'path' }
  --   }, {
  --     { name = 'cmdline' }
  --   })
  -- })
EOF
endfunction

"
" nvim-lsp
"
function! s:nvim_lsp()
lua << EOF
    local on_attach = function(client, bufnr)
        local function buf_set_keymap(...)
            vim.api.nvim_buf_set_keymap(bufnr, ...)
        end

        local opts = { noremap=true, silent=true }
        buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gh', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    end


    local capabilites =
      require('cmp_nvim_lsp')
        .default_capabilities(vim.lsp.protocol.make_client_capabilities())

    local setup = function(server)
        server.setup {
            autostart = true,
            on_attach = on_attach,
            flags = {
                debounce_text_changes = 150,
            },
            capabilites = capabilites
        }
    end

    local lspconfig = require('lspconfig')
    setup(require('ionide'))
    setup(lspconfig.ccls)
    -- setup(lspconfig.clangd)
    setup(lspconfig.tsserver)
    setup(lspconfig.rnix)
    setup(lspconfig.gopls)
    -- setup(lspconfig.rust_analyzer)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { focusable = false }
    )
EOF
endfunction

" fsharp
" autocmd BufNewFile,BufRead *.fs,*.fsx,*.fsi set filetype=fsharp
" lua require('lspconfig').fsautocomplete.setup{}

function! s:fsharp()
  let g:fsharp#lsp_auto_setup = 0
  let g:fsharp#lsp_codelens = 0

  autocmd FileType fsharp set signcolumn=yes tw=119 ts=4 sw=4 number relativenumber list

  let g:fsharp#exclude_project_directories = ['paket_files']
  let g:fsharp#fsautocomplete_command = ['fsautocomplete']
endfunction

" nix
" lua require('lspconfig').rnix-lsp.setup{}

function! s:nvim_treesitter()
lua << EOF
    require'nvim-treesitter.configs'.setup {
        sync_install = false,
        auto_install = false,
        ignore_install = {},
        highlight = {
            enable = true,
            disable = { "latex" },
            additional_vim_regex_highlighting = false,
        },
    }
EOF
endfunction

call s:fsharp()
call s:nvim_cmp()
call s:nvim_lsp()
call s:nvim_treesitter()

set statusline=
set statusline+=%#PmenuSel#
set statusline+=\ %f
set statusline+=\ %2*[%M%R%H%W]%*
" Right side of statusline
set statusline+=%#CursorColumn#
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
