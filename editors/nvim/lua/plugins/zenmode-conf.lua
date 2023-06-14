require('zen-mode').setup {
    window = {
        width = 100,
        options = {
            number = true,
            relativenumber = true,
        }
    }
}

vim.keymap.set('n', '<leader>zz', function()
    require('zen-mode').toggle()
end)

local wk = require("which-key")
wk.register({
  z = {
    name = "Zen",
    z = "Toggle",
  }
}, { prefix = "<leader>" })
