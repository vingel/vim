" Version: $Id: QuickTemplate.vim 221 2008-11-05 15:17:34Z i.feelinglucky $
" File: QuickTemplate.vim
" Maintainer: feelinglucky<i.feeilnglucky#gmail.com>
" Last Change: 2008/10/08
" Desption: quick create new file form template
" Useage:
"map <C-c><C-h> :NewQuickTemplateTab xhtml<cr>
"map <C-c><C-p> :NewQuickTemplateTab php<cr>
"map <C-c><C-j> :NewQuickTemplateTab javascript<cr>
"map <C-c><C-c> :NewQuickTemplateTab css<cr>

if exists("loaded_quick_template")
    finish
endif
let loaded_quick_template = 1

if has("win32")
    let g:QuickTemplatePath = $VIM.'/vimfiles/template/'
else
    let g:QuickTemplatePath = $HOME.'/.vim/'
endif

let g:QuickTemplateCursorFlag = '#cursor#'
let s:TemplatVersion = '$Id: QuickTemplate.vim 221 2008-11-05 15:17:34Z i.feelinglucky $'

function! NewQuickTemplate(name, mode)
    let QuickTemplate=g:QuickTemplatePath.a:name.'.tpl'

    if !filereadable(QuickTemplate)
        echo "QuickTemplate ".a:name.": not exists!"
        return
    endif

    if a:mode == 'tab'
        tabnew
    else
        new
    endif

    execute 'setlocal filetype='.a:name
    let $QuickTemplate=QuickTemplate
    0r $QuickTemplate
    unlet QuickTemplate

    normal G
    delete G

    let hasfind=search(g:QuickTemplateCursorFlag)
    if hasfind
        let line = getline('.')
        let repl = substitute(line, g:QuickTemplateCursorFlag, '', '')
        call setline('.', repl)
    endif
endfunction

com! -nargs=1 -range=% NewQuickTemplate call NewQuickTemplate(<f-args>, 'window')
if v:version > 700
    com! -nargs=1 -range=% NewQuickTemplateTab call NewQuickTemplate(<f-args>, 'tab')
endif
