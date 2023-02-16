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
    fields = {'menu', 'abbr', 'kind'},
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '',
        buffer = '﬘',
        path = '',
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  sources = {
    { name = 'luasnip', max_item_count = 5 },
    { name = 'nvim_lsp', max_item_count = 10 },
    { name = 'path' },
    { name = 'buffer', keyword_length = 5, max_item_count = 3 },
  },
})
-- Load friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()
