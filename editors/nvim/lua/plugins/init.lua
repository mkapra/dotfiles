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


return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Devicons
  -- * Used for statusline
  use({
    'kyazdani42/nvim-web-devicons',
    config = function() require('nvim-web-devicons').setup{ default=true } end,
  })

  -- Statusline
  use({
    'tamton-aquib/staline.nvim',
    config = function() require('plugins.staline-conf') end,
  })

  -- Noice
  use({
    'folke/noice.nvim',
    requires = {
      { 'MunifTanjim/nui.nvim' },
    },
    config = function() require('plugins.noice-conf') end,
  })

  -- Some lua functions
  use({
    'nvim-lua/plenary.nvim',
  })

  -- Highlight ToDo comments
  use({
    'folke/todo-comments.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
    },
    config = function() require('plugins.todo-conf') end,
  })

  -- lazygit
  use({
    'kdheepak/lazygit.nvim'
  })

  -- Telescope
  -- * If nvim version is 0.5 then branch nvim-0.5.0 is necessary
  use({
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-symbols.nvim' },
      { 'nvim-telescope/telescope-dap.nvim' },
    },
    config = function() require('plugins.telescope-conf') end,
  })

  -- Treesitter
  -- If version 0.5 is used branch '0.5-compat' is necessary
  use({
    'nvim-treesitter/nvim-treesitter',
    config = function() require('plugins.treesitter-conf') end,
  })

  -- Gitsigns
  -- * Git decorations for buffer
  use({
    'lewis6991/gitsigns.nvim',
    config = function() require('gitsigns').setup{} end,
  })

  -- which-key
  -- Display possible keybindings
  use({
    'folke/which-key.nvim',
    config = function() require('plugins.which-key-conf') end,
  })

  -- LSP
  -- Uses Mason for installing and configuring LSP. If version of nvim is lower
  -- than v0.7 then nvim-lspconfig and nvim-lsp-installer needs to be installed
  --
  -- Requires:
  --   Rust tools
  --   Commit 00e19d4b18a28ec8460dac373dffa5a49448ff6c for nvim version lower than
  --   v0.8
  use({
    'williamboman/mason.nvim',
    requires = {
      { 'williamboman/mason-lspconfig.nvim' },
      { 'neovim/nvim-lspconfig' },
      { 'simrat39/rust-tools.nvim' },
    },
    config = function() require('plugins.lsp-conf') end,
  })
  -- Breadcrumbs
  use({
    'SmiteshP/nvim-navic',
    config = function() require('nvim-navic').setup{} end,
  })
  -- Debug Adapter Control
  use({
    'mfussenegger/nvim-dap',
    requires = {
      { 'rcarriga/nvim-dap-ui' },
    },
    config = function() require('plugins.dap-conf') end,
  })

  -- Snippets
  -- LuaSnip
  use({
    'L3MON4D3/LuaSnip',
    requires = {
      { 'rafamadriz/friendly-snippets' }, -- Source: JSON style snippets for LuaSnip
      { 'saadparwaiz1/cmp_luasnip' },     -- Make LuaSnip work with cmp
    },
  })
  -- Completion engine
  use({
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',   -- Source: buffer
      'hrsh7th/cmp-nvim-lsp', -- Source: LSP symbols
      'hrsh7th/cmp-path',     -- Source: filepaths
    },
    config = function() require('plugins.cmp-conf') end,
  })

  -- Automatic Brackets
  use({
    'windwp/nvim-autopairs',
    config = function() require('nvim-autopairs').setup{} end,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

--   Plug 'mortepau/codicons.nvim'

--   " Dev Container for VS Code
--   if has('nvim-0.7.0')
--     Plug 'esensar/nvim-dev-container'
--   endif
--   require("devcontainer").setup{}
