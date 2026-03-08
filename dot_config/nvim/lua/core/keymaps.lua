local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- 移動 (折り返し考慮)
keymap("n", "j", "gj", opts)
keymap("n", "k", "gk", opts)
keymap("n", "gj", "j", opts)
keymap("n", "gk", "k", opts)
keymap("v", "j", "gj", opts)
keymap("v", "k", "gk", opts)
keymap("v", "gj", "j", opts)
keymap("v", "gk", "k", opts)

-- 対応ペアに飛ぶ
keymap("n", "<Tab>", "%", opts)
keymap("v", "<Tab>", "%", opts)

-- 行末まで選択
keymap("v", "v", "$h", opts)

-- redraw
keymap("n", "<Leader><C-L>", ":redraw!<CR>", opts)

-- ハイライトを消す
keymap("n", "gh", ":nohlsearch<CR>", opts)

-- カレントディレクトリを変更
keymap("n", "<Leader>cd", ":lcd %:h<CR>", opts)

-- ビジュアルモードで選択した文字列を検索
keymap("v", "*", '"vy/\\V<C-r>=substitute(escape(@v, \'\\/\'), "\\n", \'\\\\n\', \'g\')<CR><CR>', opts)

-- sudo で保存
keymap("c", "w!!", "w !sudo tee > /dev/null %", {})

-- ペーストモードのトグル
keymap("n", "<Leader>p", ":set paste!<CR>", opts)

-- ウィンドウ操作 (VSCode Neovim では不要)
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
