local navic = require('nvim-navic') -- breadcrumbs

require('rust-tools').setup({
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
      navic.attach(client, bufnr) -- breadcrumbs
    end,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy"
        },
      }
    }
  },
})
