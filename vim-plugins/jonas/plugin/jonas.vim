if (exists("g:loaded_jonas"))
  finish
endif
let g:loaded_jonas = '1.0'

DoMatchParen

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif
