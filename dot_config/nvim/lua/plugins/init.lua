-- VSCode Neovim環境では一部のプラグインのみを読み込む
if vim.g.vscode then
  -- VSCode Neovimで使用するプラグインのみを設定
  require("lazy").setup({
    -- 基本的な機能のみ
    {
      "tpope/vim-fugitive",
      config = function()
        vim.keymap.set("n", "<Leader>gd", ":Gdiff<CR>", { silent = true })
        vim.keymap.set("n", "<Leader>gD", ":diffoff!<CR><C-w>l:bd<CR><C-w><C-w><C-w><C-w>", { silent = true })
      end
    },
    {
      "tpope/vim-markdown"
    },
    {
      "cespare/vim-toml",
      ft = "toml"
    }
  })
  return
end

-- 通常のNeovim環境では全てのプラグインを読み込む
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Git関連
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<Leader>gd", ":Gdiff<CR>", { silent = true })
      vim.keymap.set("n", "<Leader>gD", ":diffoff!<CR><C-w>l:bd<CR><C-w><C-w><C-w><C-w>", { silent = true })
    end
  },
  {
    "gregsexton/gitv",
    dependencies = { "vim-fugitive" }
  },
  {
    "int3/vim-extradite",
    dependencies = { "vim-fugitive" }
  },

  -- ファイル操作
  {
    "Shougo/unite.vim",
    dependencies = { "Shougo/neomru.vim" },
    config = function()
      vim.cmd("source ~/.config/nvim/plugins/unite.vim")
    end
  },
  {
    "Shougo/unite-outline",
    dependencies = { "unite.vim" },
    config = function()
      vim.keymap.set("n", "[unite]o", ":<C-u>Unite -no-quit -vertical -winwidth=30 outline<CR>", { silent = true })
    end
  },

  -- スニペット
  {
    "Shougo/neosnippet.vim",
    dependencies = { "Shougo/neosnippet-snippets" }
  },

  -- 見た目
  {
    "itchyny/lightline.vim",
    config = function()
      vim.cmd("source ~/.config/nvim/plugins/lightline.vim")
    end
  },
  {
    "vim-scripts/wombat256.vim",
    config = function()
      vim.cmd("colorscheme wombat256mod")
    end
  },
  {
    "altercation/vim-colors-solarized"
  },

  -- その他
  {
    "tpope/vim-markdown"
  },
  {
    "osyo-manga/vim-over",
    config = function()
      vim.keymap.set("n", "<Leader>o", ":OverCommandLine<CR>", { silent = true })
    end
  },
  {
    "vim-scripts/surround.vim"
  },
  {
    "cespare/vim-toml",
    ft = "toml"
  }
}) 