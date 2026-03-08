local M = {}

-- メモディレクトリの設定
local memo_dir = vim.fn.expand("~/Dropbox/memo/daily/")

-- メモディレクトリが存在しない場合は作成
if vim.fn.isdirectory(memo_dir) == 0 then
  vim.fn.mkdir(memo_dir, "p")
end

-- 今日の日付を取得
local function get_today()
  return os.date("%Y-%m-%d")
end

-- 今日のメモファイルを開く
function M.open_memo_file()
  local filename = memo_dir .. get_today() .. ".md"
  
  if vim.g.vscode then
    -- VSCodeの機能を使用してファイルを作成
    vim.cmd("call VSCodeNotify('workbench.action.files.newUntitledFile')")
    -- 少し待ってからファイルを保存
    vim.defer_fn(function()
      vim.cmd("call VSCodeNotify('workbench.action.files.saveAs', '" .. filename .. "')")
    end, 100)
  else
    -- 通常のNeovim環境
    vim.cmd("edit " .. filename)
    vim.cmd("set fileencoding=utf-8")
  end
end

-- コマンドの登録
vim.api.nvim_create_user_command("MemoNow", M.open_memo_file, {})

-- キーマップの設定
vim.api.nvim_set_keymap('n', '<Leader>mn', ':MemoNow<CR>', { noremap = true, silent = true })

-- VSCode Neovim環境ではUnite関連のコマンドは不要
if not vim.g.vscode then
  vim.api.nvim_create_user_command("MemoList", "Unite file:~/Dropbox/memo/daily/ -buffer-name=memo_list", {})
  vim.api.nvim_create_user_command("MemoGrep", "Unite grep:~/Dropbox/memo/daily/ -no-quit", {})
  vim.api.nvim_create_user_command("MemoFiler", "VimFiler ~/Dropbox/memo/daily/", {})
  -- 通常のNeovim環境用のキーマップ
  vim.api.nvim_set_keymap('n', '<Leader>ml', ':MemoList<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>mf', ':MemoFiler<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>mg', ':MemoGrep<CR>', { noremap = true, silent = true })
end

return M 