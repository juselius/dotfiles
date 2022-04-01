if exists("g:loaded_hindent") || !executable("hindent")
    finish
endif
let g:loaded_hindent = 1

setlocal formatprg=hindent

