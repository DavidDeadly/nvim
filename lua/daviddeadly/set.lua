-- luacheck: globals vim

vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/vim/undodir"
vim.opt.undofile = true

vim.opt.termguicolors = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.cursorline = true

vim.opt.laststatus = 3

vim.opt.spelllang = "en_us,es"
vim.opt.spell = true

vim.opt.linespace = 10

-- popup menu, ex: cmp suggest menu
vim.opt.pumheight = 15

-- For projections.nvim save localoptions to session file
vim.opt.sessionoptions:append("localoptions")
