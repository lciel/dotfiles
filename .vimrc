" ==============================
" +++++ base
" ==============================

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
if filereadable(expand('~/.vim/plugin.vim'))
    source ~/.vim/plugin.vim
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


" ----- SEARCH
set hlsearch
set ignorecase
set smartcase
set incsearch


" ----- TAB
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab


" ----- INPUT
set backspace=indent,eol,start


" ----- VIEW
set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<
set number
set showmatch
set showcmd
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%{fugitive#statusline()}\ \ %l,%c%V%8P
set wrap
set ambiwidth=double
syntax on

hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black


" ----- FILE
filetype indent on
filetype plugin on


" ----- KEYMAP
noremap j gj
noremap k gk
vnoremap j gj
vnoremap k gk
noremap gj j
noremap gk k
vnoremap gj j
vnoremap gk k

nmap <silent> gh :nohlsearch<CR>


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

