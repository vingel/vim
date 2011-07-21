function! GJSLint()
    "let prg=&makeprg

    setlocal makeprg=gjslint\ %
    setlocal errorformat=Line\ %l,\ %t:%n:\ %m
    make

    "setlocal makeprg=prg
endfunction

command! -nargs=0 -buffer Gjslint :call GJSLint()
command! -nargs=0 -buffer GJSLint :call GJSLint()
