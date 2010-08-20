function! GET_UP_PATH(dir)
    let pos=len(a:dir)-1
    while pos>0
        if (a:dir[pos]=="/" )
            return  strpart(a:dir,0,pos)
        endif
        let pos=pos-1
    endwhile
    return  ""
endfunction

"设置相关tags
function! s:SET_TAGS()
    let dir = expand("%:p:h") "获得源文件路径
	let dir = substitute(dir, '\', '/', 'g')
    "在路径上递归向上查找tags文件
    while dir!=""
        if findfile("tags",dir ) !=""
            "找到了就加入到tags
            exec "set tags+=" . dir . "/tags"
        endif
        "得到上级路径
        let dir=GET_UP_PATH(dir)
    endwhile
endfunction


" Set this once, globally.
if !exists("g:pythonpath")
    if executable("python")
      try
python << EOF
import sys, vim
pythonpath = sys.path
pythonpath = ",".join(pythonpath)
pythonpath = pythonpath.replace('\\', '/')
vim.command("let g:pythonpath = '%s'" % pythonpath)
EOF
        "let perlpath = substitute(perlpath,',.$',',,','')
      catch /E145:/
        let g:pythonpath = ".,,"
      endtry
    else
        " If we can't call perl to get its path, just default to using the
        " current directory and the directory of the current file.
        let g:pythonpath = ".,,"
    endif
endif

function! s:SetPythonPath()
    let dir = expand("%:p:h") "获得源文件路径
	let dir = substitute(dir, '\', '/', 'g')
    "在路径上递归向上查找tags文件
    while dir!=""
        if findfile("__init__",dir ) ==""
            "找到了就加入到path，由于目录包含空格时出错，使用let
			if stridx(&path, dir) == -1
				"路径的作用域问题
				"let &l:path = &path . "," . dir
				let &l:path = g:pythonpath . "," . dir
			endif
			break
        endif
        "得到上级路径
        let dir=GET_UP_PATH(dir)
    endwhile
endfunction

autocmd BufEnter * call s:SET_TAGS()
autocmd BufEnter *.py call s:SetPythonPath()
