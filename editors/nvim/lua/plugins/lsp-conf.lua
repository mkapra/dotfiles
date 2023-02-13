require("mason").setup()

local navic = require('nvim-navic')

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
vim.opt.signcolumn = "yes" -- perma show diagnostics columns

require("mason-lspconfig").setup {
    ensure_installed = {
      "pylsp",
      "solargraph",
      "texlab",
      "rust-analyzer",
      "lua_ls",
    },
}

local lsp = require('lspconfig')
print(lsp[0])
local servers = { "pylsp", "sumneko_lua", "solargraph", "texlab", "lua-language-server" }
for _, i in ipairs(servers) do
  lsp[i].setup({
    on_attach = function(client, bufnr)
      navic.attach(client, bufnr) -- breadcrumbs
    end
  })
end
