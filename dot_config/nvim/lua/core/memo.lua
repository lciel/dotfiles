local M = {}

local memo_dir = vim.fn.expand("~/Dropbox/memo/daily/")

function M.open_memo_file()
  if vim.fn.isdirectory(memo_dir) == 0 then
    vim.fn.mkdir(memo_dir, "p")
  end
  local filename = memo_dir .. os.date("%Y-%m-%d") .. ".md"
  vim.cmd("edit " .. filename)
  vim.cmd("set fileencoding=utf-8")
end

vim.api.nvim_create_user_command("MemoNow", M.open_memo_file, {})
vim.keymap.set("n", "<Leader>mn", ":MemoNow<CR>", { noremap = true, silent = true })

-- telescope でメモ検索 (通常の nvim のみ)
if not vim.g.vscode then
  vim.keymap.set("n", "<Leader>ml", function()
    require("telescope.builtin").find_files({ cwd = memo_dir })
  end, { noremap = true, silent = true, desc = "Memo list" })

  vim.keymap.set("n", "<Leader>mg", function()
    require("telescope.builtin").live_grep({ cwd = memo_dir })
  end, { noremap = true, silent = true, desc = "Memo grep" })
end

return M
