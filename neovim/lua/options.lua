local o = vim.opt

o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.scrolloff = 4
o.wrap = false

o.ignorecase = true
o.smartcase = true

o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4

o.splitright = true
o.splitbelow = true

-- Persistent undo across sessions (lives in ~/.local/state/nvim/undo)
o.undofile = true

-- Use the system clipboard for all yank/paste operations
o.clipboard = "unnamedplus"
