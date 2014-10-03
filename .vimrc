" ==============================
" +++++ base
" ==============================

let s:is_windows = has('win95') || has('win16') || has('win32') || has('win64')
let s:is_mac = (has('mac') || has('macunix') || has('gui_macvim') || system('uname') =~? '^darwin')
let mapleader = ","

" ----- GENERAL
set ignorecase
set ruler
set showmode
set autoindent
set smartindent
set shellslash
" set autochdir
colorscheme torte

" ----- INCLUDES
if filereadable(expand('~/.vim/bundle.vim'))
    source ~/.vim/bundle.vim
endif
if filereadable(expand('~/.vim/.vimrc.local'))
    source ~/.vim/.vimrc.local
endif

" ----- for JAPANESE
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=white
match ZenkakuSpace /　/
set formatoptions+=mM
set ambiwidth=double
set display+=lastline
" ----- ENCODING
set encoding=utf-8
set fileencodings=ucs-bom,iso-2022-jp,cp932,euc-jp
"if has('win32') && has('kaoriya')
"  set ambiwidth=auto
"else
"  set ambiwidth=double
"endif
"if has('iconv')
"  let s:enc_euc = 'euc-jp'
"  let s:enc_jis = 'iso-2022-jp'
"  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
"    let s:enc_euc = 'euc-jisx0213,euc-jp'
"    let s:enc_jis = 'iso-2022-jp-3'
"  endif
"  set fileencodings&
"  let &fileencodings = &fileencodings.','.s:enc_jis.',cp932,'.s:enc_euc
"  unlet s:enc_euc
"  unlet s:enc_jis
"endif
"if has('win32unix')
"  set   termencoding=cp932
"elseif !has('macunix')
"  set   termencoding=euc-jp
"endif


" ----- SEARCH
set hlsearch
set ignorecase
set smartcase
set incsearch


" ----- TAB
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab
set smarttab
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>


" ----- INPUT
set backspace=indent,eol,start


" ----- VIEW
set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<
set number
set showmatch
set matchtime=3
set showcmd
set laststatus=2
set statusline=%<%f\ %m%r%h%w[%Y]%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%{fugitive#statusline()}\ \ %l,%c%V%8P
set wrap
set ambiwidth=double
set matchpairs& matchpairs+=<:>
syntax on

hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black
highlight Folded term=standout ctermfg=14 ctermbg=0 guifg=Cyan guibg=Black



" ----- FILE
filetype indent on
filetype plugin on
au BufNewFile,BufRead *.rb  set nowrap tabstop=2 shiftwidth=2
set nowritebackup
set nobackup
set noswapfile

" ----- KEYMAP
" 移動(折り返し考慮)
noremap j gj
noremap k gk
vnoremap j gj
vnoremap k gk
" 移動(折り返し無視)
noremap gj j
noremap gk k
vnoremap gj j
vnoremap gk k
" 対応ペアに飛ぶ
nnoremap <Tab> %
vnoremap <Tab> %
" 行末まで選択
vnoremap v $h
" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" redraw を <Leader>Ctrl + l に退避
nnoremap <Leader><C-L> :redraw!<CR>
" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>
" ハイライトを消す
nmap <silent> gh :nohlsearch<CR>
" sudo で保存
cmap w!! w !sudo tee > /dev/null %


" ----- BUFFER
set hidden


" ----- Color
set cursorline
"set cursorcolumn
"hi cursorline term=reverse cterm=none ctermbg=237
hi cursorline term=reverse cterm=none ctermbg=22
"hi cursorcolumn term=reverse cterm=none ctermbg=237
"let &t_SI = "\eP\e]50;CursorShape=1\x7\e\\"
"let &t_EI = "\eP\e]50;CursorShape=0\x7\e\\"

" ----- TODO
command! Todo edit ~/Dropbox/memo/todo.txt
nnoremap Mt :Todo <CR>

" ----- MEMO
let s:memo_dir = $HOME . '/Dropbox/memo/daily/'
function! s:open_memo_file()"
    if !isdirectory(s:memo_dir)
        call mkdir(s:memo_dir, 'p')
    endif

    let l:filename = s:memo_dir . strftime('%Y-%m-%d') . '.md'

    execute 'edit ' . l:filename
    execute 'set fenc=utf-8'
    execute '999'
    execute 'write'
endfunction augroup END"

command! -nargs=0 MemoNow call s:open_memo_file()
command! -nargs=0 MemoList :Unite file:~/Dropbox/memo/daily/ -buffer-name=memo_list
command! -nargs=0 MemoGrep :Unite grep:~/Dropbox/memo/daily/ -no-quit
command! -nargs=0 MemoFiler :VimFiler ~/Dropbox/memo/daily/

nnoremap [memo] <Nop>
nmap <Leader>m [memo]
nnoremap <silent> [memo]n :MemoNow <CR>
nnoremap <silent> [memo]l :MemoList <CR>
nnoremap <silent> [memo]f :MemoFiler <CR>
nnoremap <silent> [memo]g :MemoGrep <CR>

" ----- CLIPBOARD
if s:is_mac
    vmap <C-c> y:call system("pbcopy", getreg("\""))<CR>
    vmap <D-c> y:call system("pbcopy", getreg("\""))<CR>
    nmap <Leader><C-v> :call setreg("\"",system("pbpaste"))<CR>p
    nmap <Leader><D-v> :call setreg("\"",system("pbpaste"))<CR>p
endif

" ----- Kobito
if s:is_mac
    function! s:open_kobito(...)
        if a:0 == 0
            call system('open -a Kobito '.expand('%:p'))
        else
            call system('open -a Kobito '.join(a:000, ' '))
        endif
    endfunction

    command! -nargs=* Kobito call s:open_kobito(<f-args>)
    command! -nargs=0 KobitoClose call system("osascript -e 'tell application \"Kobito\" to quit'")
    command! -nargs=0 KobitoFocus call system("osascript -e 'tell application \"Kobito\" to activate'")
    nmap <Leader>k [kobito]
    nnoremap <silent> [kobito]o :Kobito <CR>
    nnoremap <silent> [kobito]c :KobitoClose <CR>
    nnoremap <silent> [kobito]f :KobitoFocus <CR>
endif

" ----- FOR OCTOPRESS
let s:octopress_repositry_dir = "/Users/louis/works/git/octopress/"
function! s:prepare_octopress_post(title)
    let current_dir = system("pwd")
    cd `=s:octopress_repositry_dir`
    let cmd = "bundle exec rake new_post\\[\"" . a:title . "\"\\]"
    let ret = system(cmd)
    let ret = matchstr(ret, '\(Creating new post:\s\)\zs.\+$', 0)
    return ret
endfunction
function! s:get_visual_selection()
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return lines
endfunction
function! s:post_to_octopress()
    let lines = s:get_visual_selection()
    let title = input("Input title : ")
    let file_path = s:prepare_octopress_post(title)
    if file_path == ""
        echo "Could not create new post."
        return
    endif
    e `=s:octopress_repositry_dir . file_path`
    for line in lines
        call append("$", line)
    endfor
    set fenc=utf-8
    w
endfunction
command! -nargs=0 OctopressPost call s:post_to_octopress()
vnoremap ,op :<C-u>OctopressPost<CR>

