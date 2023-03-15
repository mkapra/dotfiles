require('telescope').setup({
  defaults = {
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    windblend = 15,
    file_ignore_patterns = { "^.git/" },
    sorting_strategy = "ascending",
    layout_config = {
      vertical = {
        width = 140,
        prompt_position = "top",
        mirror = true,
      }
    },
  },
})

if vim.fn.has('nvim-0.7.2') == 1 then
  require('telescope').load_extension('dap')
end
