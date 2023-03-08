require('which-key').setup {
  layout = {
    align = "center",
  },
}

local map = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

map("n", "<leader>tt", "<cmd> ! pdflatex -shell-escape -synctex=1 %<cr>", default_opts)
map("n", "<leader>ts", "<cmd> w<CR>:silent !/Applications/Skim.app/Contents/SharedSupport/displayline <C-r>=line('.')<CR> %<.pdf<CR><CR>", default_opts)

map("n", "<leader>ie", "<cmd> lua require'telescope.builtin'.symbols{ sources = { 'emoji', 'gitmoji' } }<CR>", default_opts) -- Show emojis
map("n", "<leader>im", "<cmd> lua require'telescope.builtin'.symbols{ sources = { 'julia' } }<CR>", default_opts)            -- Show math symbols
map("n", "<leader>in", "<cmd> lua require'telescope.builtin'.symbols{ sources = { 'nerd' } }<CR>", default_opts)             -- Show nerd icons

map("n", "<leader>gg", "<cmd> LazyGit<CR>", default_opts)

map("n", "<leader>lr", "<cmd> lua vim.lsp.buf.rename()<CR>", default_opts)        -- Rename LSP symbol
map("n", "<leader>la", "<cmd> lua vim.lsp.buf.code_action()<CR>", default_opts)   -- Apply LSP code action
map("n", "<leader>ld", "<cmd> Telescope lsp_definitions<CR>", default_opts)       -- Show all LSP definitions (or jump if only 1)
map("n", "<leader>le", "<cmd> Telescope diagnostics<CR>", default_opts)           -- Show errors and warnings
map("n", "<leader>lf", "<cmd> lua vim.lsp.buf.format {async = true }<CR>", default_opts) -- Format buffer with LSP
map("n", "<leader>lh", "<cmd> lua vim.lsp.buf.hover()<CR>", default_opts)         -- Show info of symbol (double tap to enter)
map("n", "<leader>lb", "<cmd> Telescope lsp_references<CR>", default_opts)        -- Show all LSP references
map("n", "<leader>ls", "<cmd> Telescope lsp_workspace_symbols<CR>", default_opts) -- Search for LSP symbols

map("n", "<leader>bb", "<cmd> SidebarNvimToggle<CR>", default_opts)

map("n", "<leader>ff", "<cmd> Telescope find_files<CR>", default_opts)
map("n", "<leader>fg", "<cmd> Telescope live_grep<CR>", default_opts)
map("n", "<leader>fb", "<cmd> Telescope buffers<CR>", default_opts)
map("n", "<leader>fh", "<cmd> Telescope help_tags<CR>", default_opts)
map("n", "<leader>fd", "<cmd> Telescope diagnostics<CR>", default_opts)
map("n", "<leader>ft", "<cmd> TodoTelescope<CR>", default_opts)                   -- Search for LSP symbols^

if vim.fn.has('nvim-0.7') == 1 then
  map("n", "<leader>db", "<cmd> lua require'dap'.toggle_breakpoint()<CR>", default_opts)
  map("n", "<leader>dc", "<cmd> lua require'dap'.continue()<CR>", default_opts)
  map("n", "<leader>dc", "<cmd> lua require'dap'.continue()<CR>", default_opts)
  map("n", "<leader>dsi", "<cmd> lua require'dap'.step_into()<CR>", default_opts)
  map("n", "<leader>dso", "<cmd> lua require'dap'.step_over()<CR>", default_opts)
  map("n", "<leader>dr", "<cmd> lua require'dap'.repl.open()<CR>", default_opts)
  map("n", "<leader>du", "<cmd> lua require'dapui'.toggle()<CR>", default_opts)
end

if vim.fn.has('nvim-0.7') == 1 then
  local cmp = require 'cmp'
  local luasnip = require 'luasnip'
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end
  cmp.setup({
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
end

local wk = require 'which-key'
wk.register({
  ["<leader>"] = {
    b = {
      name = "Sidebar",
      b = { "Toggle sidebar" },
    },
    f = {
      name = "Telescope",
      b = { "Buffers" },
      d = { "Diagnostics" },
      f = { "Find files" },
      g = { "Grep" },
      h = { "Help Tags" },
      t = { "TODOs" },
    },
    d = {
      name = "Debug",
      b = { "Breakpoint" },
      c = { "Continue" },
      s = {
        name = "Step",
        i = { "Into" },
        o = { "Over" },
      },
      r = { "REPL" },
      u = { "Toggle UI" },
    },
    g = {
      name = "git",
      g = { "LazyGit" },
    },
    i = {
      name = "Symbols",
      e = { "Emoji" },
      m = { "Math symbol" },
      n = { "Nerd Font icon" },
    },
    l = {
      name = "LSP",
      a = { "Actions" },
      d = { "Definitions" },
      e = { "Errors" },
      f = { "Format buffer" },
      h = { "Hover information" },
      r = { "(Re)Name symbol" },
      r = { "References" },
      s = { "Symbols" },
    },
    n = { "Reset highlighting" },
    t = {
      name = "TeX",
      t = { "pdflatex" },
      s = { "skim-synctex" },
    },
  },
})
