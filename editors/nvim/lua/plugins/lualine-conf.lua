-- Show trailing whitespace
local function showTrailing()
  local space = vim.fn.search([[\s\+$]], 'nwc')
  return space ~= 0 and "TW:" .. space or ""
end

-- show wordcount in md and tex file
-- show precise count when selecting
local function showWordcount()
  if vim.bo.filetype == "md" or vim.bo.filetype == "tex" then
    if vim.fn.wordcount().visual_words == 1 then
      return tostring(vim.fn.wordcount().visual_words) .. " word"
    elseif not (vim.fn.wordcount().visual_words == nil) then
      return tostring(vim.fn.wordcount().visual_words) .. " words"
    else
      return tostring(vim.fn.wordcount().words) .. " words"
    end
  else
    return ""
  end
end

local function showLsp()
  local msg = 'No Lsp'
  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return msg
  end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      return "  " .. client.name
    end
  end
  return "  " .. msg
end

local mode_map = {
  ['n']    = '',
  ['no']   = 'O-P',
  ['nov']  = 'O-P',
  ['noV']  = 'O-P',
  ['niI']  = '',
  ['niR']  = '',
  ['niV']  = '',
  ['nt']   = '',
  ['v']    = '',
  ['vs']   = '',
  ['V']    = ' ',
  ['Vs']   = ' ',
  ['']   = ' ',
  ['s']  = ' ',
  ['S']    = 'SL',
  ['i']    = '',
  ['ic']   = '',
  ['ix']   = '',
  ['R']    = '菱',
  ['Rc']   = '菱',
  ['Rx']   = '菱',
  ['Rv']   = 'VR',
  ['Rvc']  = 'VR',
  ['Rvx']  = 'VR',
  ['c']    = '',
  ['cv']   = 'EX',
  ['ce']   = 'EX',
  ['r']    = 'R',
  ['rm']   = 'MORE',
  ['r?']   = 'CONFIRM',
  ['!']    = 'SH',
  ['t']    = 'T',
}

require('lualine').setup({
  options = {
    -- lualine comes with 'everforest' theme
    theme = 'everforest',
  },
  tabline = {
    lualine_a = {
      {
        'tabs',
        max_length = vim.o.columns / 3,
        mode = 2,
      }
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {
      require('nvim-navic').get_location
    },
    lualine_y = {},
    lualine_z = {}
  },
  -- all sections from left to right
  sections = {
    lualine_a = {
      function()
        return mode_map[vim.api.nvim_get_mode().mode] or "__"
      end
    },
    lualine_b = {
      'branch',
    },
    lualine_c = {
      {
        'filename',
        path = 1,
        shorting_target = 80,
      },
    },
    lualine_x = {
      {
        'diagnostics',
        diagnostics_color = {
          warn = { fg = "orange" },
          info = { fg = "#479bc7" },
          hint = { fg = "darkcyan" }
        },
      },
    },
    lualine_y = {
      'encoding',
      'fileformat',
      'filetype',
      { showLsp },
    },
    lualine_z = {
      { showWordcount },
      'location',
      { showTrailing }
    },
  },
})
