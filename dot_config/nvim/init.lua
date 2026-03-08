-- Leader key (must be set before plugins)
vim.g.mapleader = ","

-- Load configuration modules
require("options")
require("core.keymaps")
require("core.init")
require("plugins.init")
