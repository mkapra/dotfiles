vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pf", vim.cmd.Ex)

-- General configurations
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

require('plugins')

-- Colors
function ColorMyPencils(color)
  vim.o.background = "light"
  color = color or "rose-pine"
  vim.cmd.colorscheme(color)
end

ColorMyPencils()
