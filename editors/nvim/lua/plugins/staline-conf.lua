-- Show trailing whitespace
function ShowTrailing()
  local space = vim.fn.search([[\s\+$]], 'nwc')
  return space ~= 0 and "TW:" .. space .. " " or ""
end

-- show wordcount in md and tex file
-- show precise count when selecting
function ShowWordcount()
  if vim.bo.filetype == "markdown" or vim.bo.filetype == "tex" then
    if vim.fn.wordcount().visual_words == 1 then
      return "(" .. tostring(vim.fn.wordcount().visual_words) .. " word) "
    elseif not (vim.fn.wordcount().visual_words == nil) then
      return "(" .. tostring(vim.fn.wordcount().visual_words) .. " words) "
    else
      return "(" .. tostring(vim.fn.wordcount().words) .. " words) "
    end
  else
    return ""
  end
end

function ShowLsp()
  local msg = '( No Lsp)'  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil
  then
    return msg
  end
  for _, client in ipairs(clients) do    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1
    then
      return "(  " .. client.name .. ")"
    end
  end
  return "(  " .. msg .. ")"
end

require "staline".setup {
  sections = {
    left = { 'mode', ' ', 'branch', ' ', 'lsp' },
    mid = {},
    right = { 'line_column', '%{luaeval("ShowTrailing()")}', '%{luaeval("ShowWordcount()")}', '%{luaeval("ShowLsp()")}' }
  },
  mode_colors = {
    i = "#d4be98",
    n = "#84a598",
    c = "#8fbf7f",
    v = "#fc802d",
  },
  defaults = {
    true_colors = true,
    line_column = " [%l:%c] %p%%",
    branch_symbol = " ",
  }
}

require('stabline').setup {
    bg = "#efebd4",
    fg = "black",
    style = "bubble",
    stab_bg = "#f4f0d9",
}
