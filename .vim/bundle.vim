set nocompatible
filetype plugin indent off

if has('vim_starting')
    set runtimepath+=~/.vim/neobundle.vim/
    call neobundle#rc(expand('~/.vim/bundle/'))
endif



" ======================== ベース =========================

" ---------------------------
" vimproc
" ---------------------------
NeoBundle "Shougo/vimproc", {
    \ "build" : {
        \ "windows" : "make -f make_mingw32.mak",
        \ "cygwin"  : "make -f make_cygwin.mak",
        \ "mac"     : "make -f make_mac.mak",
        \ "unix"    : "make -f make_unix.mak",
    \ },
\ }


" ======================== ドキュメント =========================

" ---------------------------
" vimdoc-ja
" ---------------------------
NeoBundle "vim-jp/vimdoc-ja"

" ---------------------------
" vim-ref
" ---------------------------
NeoBundle "thinca/vim-ref"


" ======================== バージョン管理 =========================

" ---------------------------
" fugitive
" ---------------------------
NeoBundle "tpope/vim-fugitive"
" Gdiff
nnoremap <silent> <Leader>gd :Gdiff<CR>
" Close gdiff
nnoremap <silent> <Leader>gD :diffoff!<CR><C-w>l:bd<CR><C-w><C-w><C-w><C-w>

" ---------------------------
" gitv
" ---------------------------
NeoBundleLazy "gregsexton/gitv", {
    \ "depends": ["tpope/vim-fugitive"],
    \ "autoload": {
    \   "commands": ["Gitv"],
    \ }}
nnoremap <silent> <Leader>gv :Gitv<CR>
nnoremap <silent> <Leader>gV :Gitv --all<CR>

" ---------------------------
" extradite
" ---------------------------
NeoBundle "int3/vim-extradite"


" ======================== 入力補助 =========================

" ---------------------------
" surround.vim
" ---------------------------
NeoBundle "surround.vim"

" ---------------------------
" snipmate-snippets
" ---------------------------
NeoBundle "honza/snipmate-snippets"

" ---------------------------
" neosnippet
" ---------------------------
NeoBundleLazy "Shougo/neosnippet", {
    \ "autoload": {
    \   "depends": ["honza/snipmate-snippets"],
    \   "insert": 1,
    \ }}
imap <C-L>    <Plug>(neosnippet_expand_or_jump)
smap <C-L>    <Plug>(neosnippet_expand_or_jump)
let g:neosnippet#snippets_directory = '~/.vim/bundle/snipmate-snippets/snippets'

" ---------------------------
" emmet-vim : zencoding の後継
" ---------------------------
NeoBundleLazy "mattn/emmet-vim", {
    \ "autoload": {"filetyps": ["html"]}}

" ---------------------------
" vim-alignta
" ---------------------------
NeoBundleLazy "h1mesuke/vim-alignta", {
    \ "autoload": {"commands": ["Alignta"]}}
vnoremap <silent> => :Alignta @1 =><CR>
vnoremap <silent> = :Alignta @1 =<CR>
vnoremap <silent> == =<CR>

" ---------------------------
" yankround.vim
" ---------------------------
NeoBundle "LeafCage/yankround.vim"
nmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)
let g:yankround_max_history = 50
nnoremap <silent>g<C-p> :<C-u>CtrlPYankRound<CR>

" ---------------------------
" ctrlp.vim
" ---------------------------
NeoBundle "kien/ctrlp.vim"

" ---------------------------
" gundo.vim : undo 強化
" ---------------------------
NeoBundleLazy "sjl/gundo.vim", {
    \ "autoload": {
    \   "commands": ['GundoToggle'],
    \}}
nnoremap <Leader>gu :GundoToggle<CR>


" ======================== 補完機能 =========================

" ---------------------------
" neocomplcache
" ---------------------------
if has('lua') && v:version >= 703 && has('patch885')
    NeoBundleLazy "Shougo/neocomplete.vim", {
        \ "autoload": {
        \   "insert": 1,
        \ }}
    let g:neocomplete#enable_at_startup = 1
    let s:hooks = neobundle#get_hooks("neocomplete.vim")
    function! s:hooks.on_source(bundle)
        let g:acp_enableAtStartup = 0
        let g:neocomplet#enable_smart_case = 1
        " NeoCompleteを有効化
        " NeoCompleteEnable
    endfunction
else
    NeoBundleLazy "Shougo/neocomplcache", {
        \ "autoload": {
        \   "insert": 1,
        \}}
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplcache.
    let g:neocomplcache_enable_at_startup = 1
    " Use smartcase.
    let g:neocomplcache_enable_smart_case = 1
    " Use camel case completion.
    let g:neocomplcache_enable_camel_case_completion = 1
    " Use underbar completion.
    let g:neocomplcache_enable_underbar_completion = 1
    " Set minimum syntax keyword length.
    let g:neocomplcache_min_syntax_length = 3
    let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
    " Define dictionary.
    let g:neocomplcache_dictionary_filetype_lists = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
            \ }
    " Define keyword.
    if !exists('g:neocomplcache_keyword_patterns')
        let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
    " disable up/down key
    inoremap <expr><Up> pumvisible() ? neocomplcache#close_popup()."\<Up>" : "\<Up>"
    inoremap <expr><Down> pumvisible() ? neocomplcache#close_popup()."\<Down>" : "\<Down>"
    " disable preview
    set completeopt=menuone
endif

" ---------------------------
" rails.vim
" ---------------------------
NeoBundle "tpope/vim-rails"


" ======================== Unite =========================

" ---------------------------
" unite.vim
" ---------------------------
NeoBundleLazy "Shougo/unite.vim", {
    \ "autoload": {
    \   "commands": ["Unite", "UniteWithBufferDir"]
    \ }}
nnoremap [unite] <Nop>
nmap <Leader>u [unite]
" history/yank を有効化
let g:unite_source_history_yank_enable = 1
" バッファ一覧
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> [unite]u :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
nnoremap <silent> [unite]a :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
" yank
nnoremap <silent> [unite]y :<C-u>Unite history/yank<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q
hi uniteCandidateInputKeyword guifg=orange
" エラー回避のためとりあえず(根本解決したい)
highlight default link uniteSource__Buffer PreProc
highlight default link uniteSource__FileMru PreProc
highlight default link uniteSource__Grep PreProc

" ---------------------------
" vimfiler
" ---------------------------
NeoBundle "Shougo/vimfiler"

" ---------------------------
" unite-outline
" ---------------------------
NeoBundleLazy "h1mesuke/unite-outline", {
    \ "autoload": {
    \   "unite_sources": ["outline"],
    \ }}
nnoremap <silent> [unite]o :<C-u>Unite -no-quit -vertical -winwidth=30 outline<CR>
" エラー回避のためとりあえず(根本解決したい)
highlight default link uniteSource__Outline PreProc


" ======================== 見た目 =========================

" ---------------------------
" fontzoom
" ---------------------------
NeoBundle "thinca/vim-fontzoom"

" ---------------------------
" vim-indent-guides
" ---------------------------
NeoBundle "nathanaelkane/vim-indent-guides"
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_color_change_percent = 30
let g:indent_guides_guide_size = 1
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=235
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=237
autocmd VimEnter,Colorscheme python,ruby :hi IndentGuidesOdd ctermbg=62
autocmd VimEnter,Colorscheme python,ruby :hi IndentGuidesEven ctermbg=62

" ---------------------------
" desert256
" ---------------------------
NeoBundle "desert256.vim"


" ======================== 開発補助 =========================

" ---------------------------
" quickrun
" ---------------------------
NeoBundle "thinca/vim-quickrun"
let g:quickrun_config = {
\   "_" : {
\       "runner" : "vimproc",
\       "runner/vimproc/updatetime" : 60,
\       "outputter/buffer/split" : ":botright",
\       "outputter/buffer/close_on_empty" : 1
\   },
\   "ruby.rspec" : {
\       "command" : "rspec",
\       "cmdopt" : "bundle exec",
\       "exec" : "%o %c %s"
\   }
\}
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
augroup RSpec
  autocmd!
  autocmd BufWinEnter,BufNewFile *_spec.rb set filetype=ruby.rspec
augroup END

" ---------------------------
" project.vim
" ---------------------------
NeoBundleLazy "project.tar.gz", {
    \ "autoload": { "commands": ["Project"] }}

" ---------------------------
" processing
" ---------------------------
NeoBundle "vim-scripts/Processing"
