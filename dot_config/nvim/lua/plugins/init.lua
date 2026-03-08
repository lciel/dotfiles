-- VSCode Neovim 環境では最小限のプラグインのみ
if vim.g.vscode then
  require("lazy").setup({
    { "tpope/vim-fugitive" },
    { "kylechui/nvim-surround", event = "VeryLazy", config = true },
  })
  return
end

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Git
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<Leader>gd", ":Gdiff<CR>", { silent = true })
      vim.keymap.set("n", "<Leader>gD", ":diffoff!<CR><C-w>l:bd<CR><C-w><C-w><C-w><C-w>", { silent = true })
    end,
  },

  -- Fuzzy finder (replaces unite.vim)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<Leader>fg", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<Leader>fb", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Help tags" })
      vim.keymap.set("n", "<Leader>fr", builtin.oldfiles, { desc = "Recent files" })
      vim.keymap.set("n", "<Leader>fo", builtin.treesitter, { desc = "Outline (treesitter)" })
    end,
  },

  -- Statusline (replaces lightline.vim)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_c = {
            { "filename", path = 1 },
          },
        },
      })
    end,
  },

  -- Colorscheme
  {
    "vim-scripts/wombat256.vim",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme wombat256mod")
    end,
  },

  -- Treesitter (syntax highlighting, replaces vim-markdown/vim-toml etc.)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- nvim 0.11+ uses vim.treesitter directly; nvim-treesitter handles parser installation
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if ok then
        configs.setup({
          ensure_installed = {
            "lua", "vim", "vimdoc", "ruby", "rust", "go",
            "javascript", "typescript", "json", "toml", "yaml",
            "markdown", "markdown_inline", "bash", "html", "css",
          },
          highlight = { enable = true },
          indent = { enable = true },
        })
      else
        -- Newer nvim-treesitter without configs module
        require("nvim-treesitter").setup({
          ensure_installed = {
            "lua", "vim", "vimdoc", "ruby", "rust", "go",
            "javascript", "typescript", "json", "toml", "yaml",
            "markdown", "markdown_inline", "bash", "html", "css",
          },
        })
      end
    end,
  },

  -- Editing
  { "kylechui/nvim-surround", event = "VeryLazy", config = true },
})
