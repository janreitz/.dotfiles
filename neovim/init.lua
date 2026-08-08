-- Leaders must be set before any plugin reads them.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")
require("keymaps")
require("plugins")
require("lsp")
