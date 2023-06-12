local wk = require("which-key")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})

wk.register({
  f = {
    name = "Telescope",
    f = "Find File",
    g = "Grep",
    b = "Buffers",
  },
}, { prefix = "<leader>" })
