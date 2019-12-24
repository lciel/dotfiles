nnoremap [unite] <Nop>
nmap <Leader>u [unite]
" history/yank を有効化
let g:unite_source_history_yank_enable = 1
" インサートモードで開始
"let g:unite_enable_start_insert = 1
" バッファ一覧
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
" プロジェクトルートから
nnoremap <silent> [unite]e :<C-u>Unite file_rec/async:!<CR>
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
" grep
nnoremap <silent> [unite]g :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
nnoremap <silent> [unite]G :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>

