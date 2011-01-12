" Syntax for .LOG file.
" support Windows System Logs, Apache Logs, and any simply LOG file...
" See: http://en.wikipedia.org/wiki/ISO_8601
"      http://msdn.microsoft.com/zh-cn/library/ms141005.aspx
"      http://www.w3.org/TR/NOTE-datetime
" Author: 闲耘™(hotoo.cn[AT]xianyun.org)
" Date: 2010/05/13

" for Windows log.
syn match WindowsProfix /^\d\+\.\d\+/

"syn keyword logsKey contained message debug warning error info
syn match logsTypeSucc /\[\(success\|succ\)\]/
syn match logsTypeSucc /\[\?\(SUCCESS\|SUCC\)\]\?/
syn match logsTypeInfo /\[\(message\|info\)\]/
syn match logsTypeInfo /\[\?\(MESSAGE\|INFO\)\]\?/
"syn match logsTypeInfo /\[.\{-}\]/
"syn match logsTypeInfo /\[[^\]]*\]/
syn match logsTypeWarning /\[\(warn\|debug\|bug\)\]/
syn match logsTypeWarning /\[\?\<\(WARN\|DEBUG\|BUG\)\>\]\?/
syn match logsTypeError /\[error\]/
syn match logsTypeError /\[\?\<ERROR\>\]\?/

syn match Comments /^#.*$/
"!syn match String /"[^"]"/
"syn match String /".\{-}"/
"!syn match String /'[^']'/
"syn match String /'.\{-}'/
syn match URI /\w:\\[a-zA-Z0-9\.\\~@#$%^&\*_\-]\+/
syn match URI /\d\{1,3}\.\d\{1,3}\.\d\{1,3}\.\d\{1,3}/
syn match URI /https\?:\/\/[a-zA-Z0-9\.\/~@#$%^&\*_\-?=]\+/
syn match URI /file:\/[a-zA-Z0-9\.\/~@#$%^&\*_\-?=:]\+/
syn match Date /\d\{4}\([\-\/\.]\)\d\{1,2}\1\d\{1,2}/
syn match Date /\d\{4}年\d\{1,2}月\d\{1,2}日/
syn match Date /\d\{1,2}\([\-\/\.]\)\d\{1,2}\1\d\{4}/
syn match Date /\d\{1,2}\([\-\/\.\ ]\)\(Jan\|Feb\|Mar\|Apr\|May\|Jun\|Jul\|Aug\|Sep\|Oct\|Nov\|Dec\)\1\d\{4}/
syn match Time /\d\{1,2}:\d\{1,2}:\d\{1,2}\([\.,]\d\+\|\ +\d\+\)\?/
syn match DateTime /\d\{4}\([\-\/\.]\)\d\{1,2}\1\d\{1,2}[\ Tt]\d\{1,2}:\d\{1,2}:\d\{1,2}\([\.,]\d\+\)\?/
syn match DateTime /\(Mon\|Tue\|Wed\|Thu\|Fri\|Sat\|Sun\)\ \(Jan\|Feb\|Mar\|Apr\|May\|Jun\|Jul\|Aug\|Sep\|Oct\|Nov\|Dec\)\ \d\{1,2}\ \d\{1,2}:\d\{1,2}:\d\{1,2}\(\ \(CST\|PST\)\)\?\ \d\{4}/

"syn match   logsNumber	       "-\=\<\d\+L\=\>\|0[xX][0-9a-fA-F]\+\>"

hi logsKey guifg=#ff6600
"hi logsTypeInfo guifg=#3399ff
hi logsTypeInfo guifg=#ffffff guibg=#3399ff
hi logsTypeWarning guifg=#ff0000 guibg=#ffff00
hi logsTypeError guibg=#ff0000 guifg=#ffff00
hi logsTypeSucc guibg=#008000 guifg=#ffffff
hi Comments guifg=#666666
"hi String guifg=#55a255
hi URI gui=underline
hi Title gui=bold guifg=#cc3300
hi DateTime guifg=#8ec2f5
hi Date guifg=#8ec2f5
hi Time guifg=#8ec2f5
hi logsNumber guifg=#ff6600

hi WindowsProfix guifg=#8ec2f5
