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
})
-- Load friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()
