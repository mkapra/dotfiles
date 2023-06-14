local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(_, bufnr)
  lsp.default_keymaps({buffer = bufnr})
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "<leader>ld", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "<leader>lh", function() vim.lsp.buf.hover() end, opts)

  vim.keymap.set("n", "<leader>lod", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostig.goto_prev() end, opts)

  vim.keymap.set("n", "<leader>lrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("n", "<leader>lrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, opts)
end)

require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
require('lspconfig').texlab.setup({
  settings = {
    cmd = { 'texlab' },
    texlab = {
      build = {
        executable = 'latexmk',
        args = { '-xelatex', '-pdf', '-interaction=nonstopmode', '-synctex=1', '-shell-escape', '%f' },
        onSave = true,
      },
    },
  },
})

lsp.setup()

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
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy"
        },
      }
    }
  },
}

local cmp = require 'cmp'

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

cmp.setup({
  snippet = {
    expand = function(args) -- set a snippet engine
      require("luasnip").lsp_expand(args.body)
    end,
  },
  formatting = {
    -- Show icons in cmp box
    format = function(_, vim_item)
      local icons = require("icons").lspkind
      vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
      return vim_item
    end,
  },
  sources = {
    { name = 'luasnip', max_item_count = 5 },
    { name = 'nvim_lsp', max_item_count = 10 },
    { name = 'path', dup = 0 },
    { name = 'buffer', keyword_length = 5, max_item_count = 3 },
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<A-q>'] = cmp.mapping.close(),
    ['<A-o>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<A-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<Tab>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    }),
  }
})

-- Load friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()

local wk = require("which-key")
wk.register({
  l = {
    name = "Lsp",
    a = { "Code Action" },
    d = "Definition",
    h = "Hover",
    o = {
      name = "Open",
      d = "Diagnostic Float",
    },
    r = {
      n = "Rename",
      r = "References",
    },
  },
}, { prefix = "<leader>" })
