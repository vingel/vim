" File: Alipay.uisvr.vim
" Desption: uisvr 1.5 support for alipay sofaMVC.
" @usage :Uisvr
"        :Uisvr css
"        :Uisvr js split
"        :Uisvr vm
"        :Uisvr xml    -> uisvr/config/config.xml
"        :Uisvr css.vm -> uisvr/config/css.vm
"        :Uisvr js.vm  -> uisvr/config/js.vm
" TODO: 已经打开的文件，不再新建窗口。
" TODO: :Uisvr config[ xml|js|css]
" TODO: 老版 uisvr 支持(maybe)。
" Author: 闲耘™(hotoo.cn[AT]gmail.com)
" Version: 1.6
" Last Change: 2011/07/21

if exists('loaded_alipay_uisvr')
    finish
endif
let loaded_alipay_uisvr=1

" default alipay uisvr path.
if !exists('g:alipay_uisvr_path')
    let g:alipay_uisvr_path = ''
endif

let s:sp = "/"
if has("win32") && exists("+shellslash") && !(&shellslash)
    let s:sp = '\\'
endif

" @param {String} filetype in [js, css, vm, xml]
" @param {String} open buffer type, like [new, vsp, sp, tabnew, ...]
function! s:uisvr(...)
    let ft = expand("%:e")
    if "js"!=ft && "css"!=ft && "vm"!=ft
        echohl WarningMsg
        echo "请在 JavaScript, CSS 和 Velocity 文件下执行 :Uisvr 命令。"
        echohl None
        return
    endif
    let fname = expand("%:r")
    let fpath = expand("%:p")
    let fdir = expand("%:p:h")

    if a:0 == 0
        if "css"==ft || "js"==ft
            let targetType = "vm"
        elseif "vm"==ft
            let targetType = "js"
        endif
        let win = "new"
    elseif a:0 == 1
        let targetType = a:1
        let win = "new"
    else
        let targetType = a:1
        let win = a:2
    endif

    if "js"!=targetType && "css"!=targetType && "vm"!=targetType &&
            \ "xml"!=targetType && "css.vm"!=targetType && "js.vm"!=targetType
        echohl WarningMsg
        echo ":Uisvr [css|js|vm|xml|css.vm|js.vm] [new|vsp|tabnew|...]"
        echohl None
        return
    endif

    let paths = s:getPaths()

    exec win . " " . fnamemodify(paths[targetType], ":p")
endfunction

function! s:getPaths()
    let src_ext = expand("%:e")
    let src_filename = expand("%:r")
    let src_dir = expand("%:p:h")
    let src_path = expand("%:p")
    let uisvrDir = finddir('uisvr', expand('%:p:h').';')
    if "vm"==src_ext
        let car = substitute(src_dir, '^.*' . s:sp . 'templates' . s:sp . '\([a-zA-Z0-9]\+\)' . s:sp . 'screen' . s:sp . '.*$', '\1', "")
        let subpath = substitute(src_dir, '^.*' . s:sp . 'templates' . s:sp . car . s:sp . 'screen', '', "")
    elseif "js"==src_ext || "css"==src_ext
        let car = substitute(src_dir, '^.*' . s:sp . 'uisvr' . s:sp . '\([a-zA-Z0-9]\+\)\($\|' . s:sp . '.*$\)', '\1', "")
        let subpath = substitute(src_dir, '^.*' . s:sp . 'uisvr' . s:sp . car, '\1', "")
    else
        return
    endif
    let uisvrDir = fnamemodify(uisvrDir, ":p")
    let path = {
        \ "css" : uisvrDir . s:sp . car . subpath . s:sp . src_filename . ".css",
        \ "js"  : uisvrDir . s:sp . car . subpath . s:sp . src_filename . ".js",
        \ "vm"  : uisvrDir . s:sp . ".." . s:sp . "templates" . s:sp . car . s:sp . "screen" . subpath . s:sp . src_filename . ".vm",
        \ "xml" : uisvrDir . s:sp . "config" . s:sp . "config.xml",
        \ "js.vm" : uisvrDir . s:sp . "config" . s:sp . "js.vm",
        \ "css.vm" : uisvrDir . s:sp . "config" . s:sp . "css.vm"
        \ }
    return path
endfunction

command -nargs=* Uisvr call <SID>uisvr(<f-args>)
command -nargs=* UISvr call <SID>uisvr(<f-args>)
command -nargs=* UISVR call <SID>uisvr(<f-args>)

" htdocs
"   +-- htdocs
"   +-- templates
"   |    +-- car0
"   |    |    +-- layout
"   |    |    +-- message
"   |    |    +-- screen
"   |    |    |    `-- index.vm
"   |    |    `-- tile
"   |    `-- car1
"   |         +-- layout
"   |         +-- message
"   |         +-- screen
"   |         |    `-- index.vm
"   |         `-- tile
"   `-- uisvr
"        +-- config
"        |    +-- config.xml
"        |    +-- css.vm
"        |    `-- js.vm
"        +-- car0
"        |    +-- index.css
"        |    `-- index.js
"        +-- car1
"        |    +-- index.css
"        |    `-- index.js
"        `-- theme
"             +-- car0
"             |    +-- foot.vm
"             |    `-- head.vm
"             `-- car1
"                  +-- foot.vm
"                  `-- head.vm
