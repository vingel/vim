" File: Alipay.uisvr.vim
" Desption: uisvr 1.5 support for alipay sofaMVC.
" @usage
"        :Uisvr [js|css|vm [opening-window]]
"        :Uisvr config [xml|js|css [opening-window]]
"        :Uisvr theme [xml|js|css [opening-window]]
"
"        :Uisvr css             -> uisvr/{carName}/[path/to/]{fileName}.css
"        :Uisvr js split        -> uisvr/{carName}/[path/to/]{fileName}.js
"        :Uisvr vm tabnew       -> templates/{carName}/[path/to/]{fileName}.vm
"
"        :Uisvr config          -> uisvr/config/config.xml
"        :Uisvr xml             -> uisvr/config/config.xml
"        :Uisvr config xml      -> uisvr/config/config.xml
"
"        :Uisvr js.vm           -> uisvr/config/js.vm
"        :Uisvr config js       -> uisvr/config/js.vm
"        :Uisvr config js.vm    -> uisvr/config/js.vm
"
"        :Uisvr config css      -> uisvr/config/css.vm
"        :Uisvr config css.vm   -> uisvr/config/css.vm
"        :Uisvr css.vm          -> uisvr/config/css.vm
"
"        :Uisvr head            -> uisvr/theme/{carName}/head.vm
"        :Uisvr head.vm         -> uisvr/theme/{carName}/head.vm
"        :Uisvr theme head      -> uisvr/theme/{carName}/head.vm
"        :Uisvr theme head.vm   -> uisvr/theme/{carName}/head.vm
"
"        :Uisvr foot            -> uisvr/theme/{carName}/foot.vm
"        :Uisvr foot.vm         -> uisvr/theme/{carName}/foot.vm
"        :Uisvr theme foot      -> uisvr/theme/{carName}/foot.vm
"        :Uisvr theme foot.vm   -> uisvr/theme/{carName}/foot.vm
"
" TODO: 已经打开的文件，不再新建窗口。
" Author: 闲耘™(hotoo.cn[AT]gmail.com)
" Version: 1.5
" Last Change: 2011/09/22

if exists('loaded_alipay_uisvr')
    finish
endif
let loaded_alipay_uisvr=1

if !exists('g:uisvr_opening_window')
    let g:uisvr_opening_window = "new"
endif

let s:sp = '/'
if has("win32") && exists("+shellslash") && !(&shellslash)
    let s:sp = '\\'
endif

function! s:warning(msg)
    echohl WarningMsg
    echo a:msg
    echohl None
endfunction
function! s:error(msg)
    echohl ErrorMsg
    echo a:msg
    echohl None
endfunction

" @param {String} filetype in [js, css, vm, xml]
" @param {String} open buffer type, like [new, vsp, sp, tabnew, ...]
function! s:uisvr(...)
    let ft = expand("%:e")
    if "js"!=ft && "css"!=ft && "vm"!=ft && "xml"!=ft
        call s:error("Not support this filetype.")
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
        let win = g:uisvr_opening_window
    elseif a:0 == 1
        if "config" == a:1
            let targetType = "xml"
        elseif "theme" == a:1
            let targetType = "head.vm"
        else
            let targetType = a:1
        endif
        let win = g:uisvr_opening_window
    elseif a:0 == 2
        if "config" == a:1
            if "xml" == a:2
                let targetType = "xml"
            elseif "js" == a:2 || "js.vm" == a:2
                let targetType = "js.vm"
            elseif "css" == a:2 || "css.vm" == a:2
                let targetType = "css.vm"
            else
                call s:warning(":help uisvr-usage")
                return
            endif
            let win = g:uisvr_opening_window
        elseif "theme" == a:1
            if "head" == a:2 || "head.vm" == a:2
                let targetType = "head.vm"
            elseif "foot" == a:2 || "foot.vm" == a:2
                let targetType = "foot.vm"
            else
                call s:warning(":help uisvr-usage")
                return
            endif
            let win = g:uisvr_opening_window
        else
            let targetType = a:1
            let win = a:2
        endif
    else
        if "config" == a:1
            if "xml" == a:2
                let targetType = "xml"
            elseif "js" == a:2 || "js.vm" == a:2
                let targetType = "js.vm"
            elseif "css" == a:2 || "css.vm" == a:2
                let targetType = "css.vm"
            else
                call s:warning(":help uisvr-usage")
                return
            endif
            let win = a:3
        elseif "theme" == a:1
            if "head" == a:2 || "head.vm" == a:2
                let targetType = "head.vm"
            elseif "foot" == a:2 || "foot.vm" == a:2
                let targetType = "foot.vm"
            else
                call s:warning(":help uisvr-usage")
                return
            endif
            let win = a:3
        else
            call s:warning(":help uisvr-usage")
            return
        endif
    endif

    if "js"!=targetType && "css"!=targetType && "vm"!=targetType &&
            \ "xml"!=targetType && "css.vm"!=targetType && "js.vm"!=targetType &&
            \ "head.vm"!=targetType && "foot.vm"!=targetType
        call s:warning(":help uisvr-usage")
        return
    endif

    let paths = s:getPaths()
    if(has_key(paths, targetType))
        exec win . ' ' . fnamemodify(paths[targetType], ':p')
    endif
endfunction

function! s:getPaths()
    let src_ext = expand('%:e')
    let src_filename = expand('%:t:r')
    let src_dir = expand('%:p:h')
    let src_path = expand('%:p')
    let uisvrDir = finddir('uisvr', expand('%:p:h').';')
    if uisvrDir == ""
        call s:error("Not support this project.")
        return
    endif
    if "vm"==src_ext
        let car = substitute(src_dir, '^.*' . s:sp . 'templates' . s:sp . '\([a-zA-Z0-9]\+\)' . s:sp . 'screen\($\|' . s:sp . '.*$\)', '\1', '')
        let subpath = substitute(src_dir, '^.*' . s:sp . 'templates' . s:sp . car . s:sp . 'screen', '', '')
    elseif "js"==src_ext || "css"==src_ext
        let car = substitute(src_dir, '^.*' . s:sp . 'uisvr' . s:sp . '\([a-zA-Z0-9]\+\)\($\|' . s:sp . '.*$\)', '\1', '')
        let subpath = substitute(src_dir, '^.*' . s:sp . 'uisvr' . s:sp . car, '\1', '')
    else
        call s:error("Not support this filetype.")
        return
    endif
    let uisvrDir = fnamemodify(uisvrDir, ':p')
    let path = {
        \ 'css' : uisvrDir . s:sp . car . subpath . s:sp . src_filename . '.css',
        \ 'js'  : uisvrDir . s:sp . car . subpath . s:sp . src_filename . '.js',
        \ 'vm'  : uisvrDir . s:sp . '..' . s:sp . 'templates' . s:sp . car . s:sp . 'screen' . subpath . s:sp . src_filename . '.vm',
        \ 'xml' : uisvrDir . s:sp . 'config' . s:sp . 'config.xml',
        \ 'js.vm' : uisvrDir . s:sp . 'config' . s:sp . 'js.vm',
        \ 'css.vm' : uisvrDir . s:sp . 'config' . s:sp . 'css.vm',
        \ 'head.vm' : uisvrDir . s:sp . 'theme' . s:sp . car . s:sp . 'head.vm',
        \ 'foot.vm' : uisvrDir . s:sp . 'theme' . s:sp . car . s:sp . 'foot.vm'
        \ }
    return path
endfunction

"command -nargs=* Uisvr call <SID>uisvr(<f-args>)
"command -nargs=* UISvr call <SID>uisvr(<f-args>)
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
