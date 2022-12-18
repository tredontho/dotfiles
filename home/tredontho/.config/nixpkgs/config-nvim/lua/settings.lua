local opt = vim.opt
local g = vim.g

opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 0
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.relativenumber = true
opt.number = true
opt.signcolumn = "yes:2"

g.mapleader = ','

vim.cmd("syntax enable")
opt.background = "dark"
vim.cmd("colorscheme sonokai")
