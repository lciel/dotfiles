set nocompatible
filetype plugin indent off

if has('vim_starting')
    set runtimepath+=~/.vim/neobundle.vim/
    call neobundle#rc(expand('~/.vim/bundle/'))
endif

" -----------------------------------------------

" ドキュメント
NeoBundle "vim-jp/vimdoc-ja"
NeoBundle "thinca/vim-ref"

" バージョン管理
NeoBundle "tpope/vim-fugitive"
NeoBundle "gregsexton/gitv"
NeoBundle "int3/vim-extradite"

" 入力補助
NeoBundle "surround.vim"
NeoBundle "Shougo/neosnippet"
NeoBundle "honza/snipmate-snippets"
NeoBundle "mattn/zencoding-vim"
NeoBundle "h1mesuke/vim-alignta"

" 補完機能
NeoBundle "Shougo/neocomplcache"
NeoBundle "rails.vim"

" vimproc
NeoBundle "Shougo/vimproc", {
    \ "build" : {
        \ "windows" : "make -f make_mingw32.mak",
        \ "cygwin"  : "make -f make_cygwin.mak",
        \ "mac"     : "make -f make_mac.mak",
        \ "unix"    : "make -f make_unix.mak",
    \ },
\ }

" unite
NeoBundle "Shougo/unite.vim"
NeoBundle "Shougo/vimfiler"
NeoBundle "h1mesuke/unite-outline"

" 見た目
NeoBundle "thinca/vim-fontzoom"
NeoBundle "nathanaelkane/vim-indent-guides"
NeoBundle "desert256.vim"

" 開発補助
NeoBundle "thinca/vim-quickrun"
NeoBundle "project.tar.gz"
NeoBundle "vim-scripts/Processing"
