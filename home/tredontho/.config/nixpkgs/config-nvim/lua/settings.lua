local opt = vim.opt
local g = vim.g

opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.relativenumber = true
opt.number = true
opt.signcolumn = "yes:2"

g.mapleader = ','

vim.cmd("syntax enable")
opt.background = "dark"
vim.cmd("colorscheme monokai_pro")
