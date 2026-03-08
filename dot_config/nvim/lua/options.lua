local options = {
	-- 基本設定
	encoding = "utf-8",
	fileencoding = "utf-8",
	title = true,
	backup = false,
	writebackup = false,
	swapfile = false,
	undofile = true,
	clipboard = "unnamedplus",

	-- 表示設定
	number = true,
	relativenumber = false,
	numberwidth = 4,
	signcolumn = "yes",
	cursorline = true,
	showmode = false,
	showtabline = 2,
	cmdheight = 2,
	pumheight = 10,
	winblend = 0,
	pumblend = 5,
	scrolloff = 8,
	sidescrolloff = 8,
	splitbelow = false,
	splitright = false,

	-- 検索設定
	hlsearch = true,
	ignorecase = true,
	smartcase = true,
	incsearch = true,

	-- インデント設定
	expandtab = true,
	shiftwidth = 2,
	tabstop = 2,
	smartindent = true,

	-- 補完設定
	completeopt = { "menuone", "noselect" },
	wildoptions = "pum",

	-- その他
	timeoutlen = 300,
	updatetime = 300,
	termguicolors = true,
	background = "dark",
	mouse = "a",
	conceallevel = 0,
}

-- オプションの適用
for k, v in pairs(options) do
	vim.opt[k] = v
end

-- 追加の設定
vim.opt.shortmess:append("c")
vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]])
