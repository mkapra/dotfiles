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
    globalstatus = true,
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
      'filetype',
      'encoding',
      'fileformat',
      -- show wordcount in md and tex file
      -- show precise count when selecting
      function()
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
    },
    lualine_z = {
      'progress',
      'location',
      -- Show trailing whitespace
      function()
        local space = vim.fn.search([[\s\+$]], 'nwc')
        return space ~= 0 and "TW:" .. space or ""
      end
    },
  },
})
