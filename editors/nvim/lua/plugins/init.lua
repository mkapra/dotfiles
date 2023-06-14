local fn = vim.fn

-- This should auto install packer, if it is not installed on system
-- Otherwise use:
-- git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  })
end

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require('plugins.treesitter-conf') end,
  }

  -- Colorscheme
  use {
    'rose-pine/neovim',
    as = 'rose-pine',
    config = function()
      vim.cmd('colorscheme rose-pine')
    end,
  }

  use {
    'folke/zen-mode.nvim',
    config = function() require('plugins.zenmode-conf') end,
  }

  -- use {
  --   'mbbill/undotree',
  --   config = function()
  --     vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
  --   end
  -- }

  -- Highlight TODO comments
  use {
    'folke/todo-comments.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
    },
    config = function() require("todo-comments").setup() end,
  }

  -- Commenting
  use {
    'terrortylor/nvim-comment',
    config = function() require('nvim_comment').setup() end,
  }

  use {
    'nmac427/guess-indent.nvim',
    config = function() require('guess-indent').setup {} end,
  }

  -- Automatic Brackets
  use({
    'windwp/nvim-autopairs',
    config = function() require('nvim-autopairs').setup{} end,
  })

  -- Nicer messages and commandline
  use {
    "folke/noice.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
    },
    config = function() require('plugins.noice-conf') end,
  }

  -- Gitsigns
  -- * Git decorations for buffer
  use({
    'lewis6991/gitsigns.nvim',
    config = function() require('gitsigns').setup{} end,
  })

  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    requires = {
      { 'nvim-lua/plenary.nvim' }
    },
    config = function() require('plugins.telescope-conf') end,
  }

  -- LSP
  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {
        'williamboman/mason.nvim',
        run = ':MasonUpdate',
      },
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},

      -- More speficic language support
      {'simrat39/rust-tools.nvim'},
    },
    config = function() require('plugins.lsp-conf') end,
  }

  -- Statusline
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function() require('plugins.lualine-conf') end,
  }

  -- Keybindings helper
  use {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup {}
    end
  }
end)
