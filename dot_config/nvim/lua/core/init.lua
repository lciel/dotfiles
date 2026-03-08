-- 基本設定の読み込み
require("options")

-- キーマッピングの読み込み
require("core.keymaps")

-- メモ機能の読み込み
require("core.memo")

-- 日本語関連の設定
vim.cmd([[
  highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=white
  match ZenkakuSpace /　/
  set formatoptions+=mM
  set ambiwidth=double
  set display+=lastline
]])

-- ファイルタイプの設定
vim.cmd([[
  filetype indent on
  filetype plugin on
  au BufNewFile,BufRead *.rb set nowrap tabstop=2 shiftwidth=2
  au BufNewFile,BufRead *.rs set nowrap tabstop=2 shiftwidth=2
]])

-- シンタックスハイライト
vim.cmd("syntax on")

-- VSCode Neovim固有の設定
if vim.g.vscode then
  -- VSCode Neovim用の設定
  vim.cmd([[
    set hidden
    set nobackup
    set nowritebackup
    set noswapfile
    set clipboard=unnamedplus
  ]])
end 