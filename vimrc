" == basic ==

syntax on
filetype plugin indent on

set nocompatible
set number
set nowrap
set showmode
set textwidth=80
set tabstop=4
set shiftwidth=4
set softtabstop=4
set colorcolumn=80
set smartcase
set smarttab
set smartindent
set autoindent
set expandtab
set mouse=a
set history=1000
set completeopt=menuone,menu,longest
set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
set wildmode=longest,list,full
set wildmenu
set completeopt+=longest
set cmdheight=1
set undodir=~/.vimundo
set viewdir=~/.vimviews
set directory=~/.vimswap
set undofile
set undolevels=1000
set undoreload=10000
set backspace=indent,eol,start
set shell=/bin/sh "fix for fish
set nohlsearch
set nofoldenable
set termguicolors

if !has('nvim')
    set clipboard=unnamedplus,autoselect
endif

noremap <C-.> @:
noremap <C-C> "+y
noremap <C-A> "+p

" zap the damned Ex mode.
nnoremap Q <nop>

" execute pathogen#infect()

colorscheme NeoSolarized
set background=dark
let g:neosolarized_contrast = "high"
let g:neosolarized_visibility = "normal"


" == syntastic ==

map <Leader>s :SyntasticToggleMode<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

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
autocmd VimEnter * NoMatchParen

set updatetime=1500
