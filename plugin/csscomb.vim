"=============================================================================
" File: csscomb.vim
" Author: Aleksandr Batsuev (alex@batsuev.com)
" WebPage: https://github.com/batsuev/csscomb-vim
" License: MIT

let g:CSSCombPluginDir = fnamemodify(expand("<sfile>"), ":h")

function! g:CSSComb(count, line1, line2)
    let content = join(getline(a:line1, a:line2), "\n")
    let res = system("php ".fnameescape(g:CSSCombPluginDir."/exec.php"), content)
    let lines = split(res, "\n")
    call setline(a:line1, lines)
endfunction

command! -nargs=? -range=% CSSComb :call g:CSSComb(<count>, <line1>, <line2>, <f-args>)
