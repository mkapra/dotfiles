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
      "texlab",
      "rust_analyzer",
      "lua_ls",
    },
}

local lsp = require('lspconfig')

function my_attach (client, bufnr)
  navic.attach(client, bufnr)
end

local servers = { "texlab", "lua_ls" }
for _, i in ipairs(servers) do
  lsp[i].setup({
    on_attach = function(client, bufnr)
      my_attach(client, bufnr)
    end
  })
end

-- LaTeX (build with `:TexlabBuild`)
-- Extra config for autocompile
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/texlab.lua
lsp.texlab.setup({
  on_attach = function(client, bufnr)
    my_attach(client, bufnr)
  end,
  settings = {
    cmd = { 'texlab' },
    texlab = {
      build = {
        executable = 'latexmk',
        args = { '-xelatex', '-interaction=nonstopmode', '-synctex=1', '-shell-escape', '%f' },
        onSave = true,
      }
    }
  }
})

-- Rust (use rust-tools to setup lsp, because it has more features)
require('rust-tools').setup{
  tools = {
    autoSetHints = true,
    inlay_hints = {
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },
  server = { -- these settings go directly to lsp
    on_attach = function(client, bufnr)
      my_attach(client, bufnr)
    end,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy"
        },
      }
    }
  },
}

