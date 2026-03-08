" fork http://superbrothers.hatenablog.com/entry/2013/09/12/230608

" todoリストを簡単に入力する
abbreviate tl - [ ]

" 基本は折りたたみを開いたまま
setlocal foldlevel=10

" 入れ子のリストを折りたたむ
setlocal foldmethod=expr
setlocal foldexpr=MkdListFold(v:lnum)
setlocal foldtext=MkdListFoldText()
function! MkdListFold(lnum)
    let line = getline(a:lnum)
    let next = getline(a:lnum + 1)
    let nowIndentLevel = MkdGetIndentLevel(line)
    " リストでなければスルー
    if nowIndentLevel == 0
        return 0
    endif
    let nextIndentLevel = MkdGetIndentLevel(next)
    if nowIndentLevel < nextIndentLevel " 折り畳み開始位置
        return nowIndentLevel
    elseif nowIndentLevel > nextIndentLevel " 折り畳み終了位置
        return MkdMakeEndString(nowIndentLevel - 1)
    elseif nowIndentLevel == nextIndentLevel && nowIndentLevel != 1 " 折りたたみ継続位置
        return nowIndentLevel - 1
    endif
    return 0
endfunction
function! MkdGetIndentLevel(line)
    if a:line =~ '^[-*] '
        return 1
    elseif a:line =~ '^ \{4\}[-*] '
        return 2
    elseif a:line =~ '^ \{8\}[-*] '
        return 3
    elseif a:line =~ '^ \{12\}[-*] '
        return 4
    elseif a:line =~ '^ \{16\}[-*] '
        return 5
    endif
    return 0
endfunction
function! MkdMakeEndString(indent)
    if a:indent > 0 && a:indent <= 5
        return '<' . a:indent
    endif
    return 0
endfunction
function! MkdListFoldText()
    return getline(v:foldstart) . ' [' . (v:foldend - v:foldstart) . '] '
endfunction

" todoリストのon/offを切り替える
nnoremap <buffer> <Leader><Leader> :call ToggleCheckbox()<CR>
vnoremap <buffer> <Leader><Leader> :call ToggleCheckbox()<CR>

" 選択行のチェックボックスを切り替える
function! ToggleCheckbox()
  let l:line = getline('.')
  if l:line =~ '-\s\[\s\]'
    " 完了時刻を挿入する
    let l:result = substitute(l:line, '-\s\[\s\]', '- [x]', '') . ' [' . strftime("%Y/%m/%d (%a) %H:%M") . ']'
    call setline('.', l:result)
  elseif l:line =~ '\-\s\[x\]'
    let l:result = substitute(substitute(l:line, '-\s\[x\]', '- [ ]', ''), '\s\[\d\{4}.\+]$', '', '')
    call setline('.', l:result)
  end
endfunction

syn match MkdCheckboxMark /-\s\[x\]\s.\+/ display containedin=ALL
hi MkdCheckboxMark ctermfg=green
syn match MkdCheckboxUnmark /-\s\[\s\]\s.\+/ display containedin=ALL
hi MkdCheckboxUnmark ctermfg=red
