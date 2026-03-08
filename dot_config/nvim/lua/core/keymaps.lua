local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- リーダーキーの設定
vim.g.mapleader = ","

-- ノーマルモードのキーマッピング
keymap("n", "j", "gj", opts)
keymap("n", "k", "gk", opts)
keymap("n", "gj", "j", opts)
keymap("n", "gk", "k", opts)
keymap("n", "<Tab>", "%", opts)
keymap("n", "<Leader><C-L>", ":redraw!<CR>", opts)
keymap("n", "gh", ":nohlsearch<CR>", opts)
keymap("n", "<Leader>cd", "lcd %:h<CR>", opts)

-- ビジュアルモードのキーマッピング
keymap("v", "j", "gj", opts)
keymap("v", "k", "gk", opts)
keymap("v", "gj", "j", opts)
keymap("v", "gk", "k", opts)
keymap("v", "<Tab>", "%", opts)
keymap("v", "v", "$h", opts)

-- ウィンドウ操作（VSCode Neovimでは不要な場合がある）
if not vim.g.vscode then
  keymap("n", "<C-h>", "<C-w>h", opts)
  keymap("n", "<C-j>", "<C-w>j", opts)
  keymap("n", "<C-k>", "<C-w>k", opts)
  keymap("n", "<C-l>", "<C-w>l", opts)
  keymap("n", "<S-Left>", "<C-w><", opts)
  keymap("n", "<S-Right>", "<C-w>>", opts)
  keymap("n", "<S-Up>", "<C-w>-", opts)
  keymap("n", "<S-Down>", "<C-w>+", opts)
end

-- メモ関連
keymap("n", "<Leader>mn", ":MemoNow<CR>", opts)
keymap("n", "<Leader>ml", ":MemoList<CR>", opts)
keymap("n", "<Leader>mf", ":MemoFiler<CR>", opts)
keymap("n", "<Leader>mg", ":MemoGrep<CR>", opts)

-- クリップボード（Macの場合）
if vim.fn.has("mac") == 1 then
  keymap("v", "<C-c>", 'y:call system("pbcopy", getreg("\\""))<CR>', opts)
  keymap("n", "<Leader><C-v>", ':call setreg("\\"",system("pbpaste"))<CR>p', opts)
end

-- ペーストモードのトグル
keymap("n", "<Leader>p", ":set paste!<CR>", opts) 