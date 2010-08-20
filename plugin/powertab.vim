" File:          powertab.vim
" Author:        Vingel <http://www.vingel.com/>
" Last Updated:  2010-01-05 11:07:21
" Version:       0.1
" Description:   powertab is tab mapping for you to jump over between '' , "", (), <>,><,[], and {} in insert mode
"                :h powertab.txt

if exists('loaded_powertab') || &cp || version < 700
	finish
endif
let loaded_powertab = 1

command! Powertab :call Powertab()
imap <c-i> <c-o>:Powertab<cr>

function! Powertab () 
    let l:lists = []
    execute 'inoremap <Esc>f"a'
    execute 'inoremap <Esc>f<a'
    execute 'inoremap <Esc>f[a'
    execute 'inoremap <Esc>f(a'
    execute 'inoremap <Esc>f{a'
    execute 'inoremap <Esc>f"'
endfunction
