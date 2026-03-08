-- 日本語関連の設定
vim.cmd([[
  highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=white
  match ZenkakuSpace /　/
  set formatoptions+=mM
  set display+=lastline
]])

-- カーソル行のハイライト
vim.cmd([[
  hi clear CursorLine
  hi CursorLine gui=underline
  highlight CursorLine ctermbg=black guibg=black
  highlight Folded term=standout ctermfg=14 ctermbg=0 guifg=Cyan guibg=Black
]])

-- ファイルタイプの設定
vim.filetype.add({
  pattern = {
    ["*.rb"] = function(_, bufnr)
      vim.bo[bufnr].tabstop = 2
      vim.bo[bufnr].shiftwidth = 2
      vim.bo[bufnr].wrap = false
    end,
    ["*.rs"] = function(_, bufnr)
      vim.bo[bufnr].tabstop = 2
      vim.bo[bufnr].shiftwidth = 2
      vim.bo[bufnr].wrap = false
    end,
  },
})

-- シンタックスハイライト
vim.cmd("syntax on")
vim.cmd("filetype indent on")
vim.cmd("filetype plugin on")

-- VSCode Neovim 固有の設定
if vim.g.vscode then
  vim.opt.clipboard = "unnamedplus"
end
