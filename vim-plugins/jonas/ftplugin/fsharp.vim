let g:LanguageClient_serverCommands = {
  \ 'fsharp': g:fsharp#languageserver_command
  \ }

if has('nvim') && exists('*nvim_open_win')
  augroup FSharpShowTooltip
    autocmd!
    autocmd CursorHold call fsharp#showTooltip()
  augroup END
endif

