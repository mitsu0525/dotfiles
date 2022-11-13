local executable = function(x)
  return vim.fn.executable(x) == 1
end

vim.cmd('packadd vim-jetpack')
require('jetpack.packer').startup(function(use)
  use { 'tani/vim-jetpack', opt = 1 }-- bootstrap

  use 'folke/tokyonight.nvim'

  use 'kyazdani42/nvim-web-devicons' -- File icons

  use 'nvim-lualine/lualine.nvim' -- Statusline
  use 'akinsho/nvim-bufferline.lua'

  use {'kkharji/sqlite.lua', config = function()
    vim.g.sqlite_clib_path = "~/bin/sqlite3.dll"
  end }
  use 'nvim-lua/plenary.nvim' -- Common utilities
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-file-browser.nvim'
  use 'nvim-telescope/telescope-frecency.nvim'
  -- use 'nvim-telescope/telescope-smart-history.nvim'

  use 'windwp/nvim-autopairs'
  use 'numToStr/Comment.nvim'

  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'glepnir/lspsaga.nvim'

  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'

  use 'tyru/capture.vim'
  -- use 'norcalli/nvim-colorizer.lua'
  use 'uga-rosa/ccc.nvim'

  -- For vsnip users.
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'

  -- use 'tpope/vim-fugitive'
  -- ddc.vim
  -- if executable 'deno' then
  --   use 'vim-denops/denops.vim'
  --   use 'lambdalisue/gin.vim'
  --   -- use 'lambdalisue/guise.vim'
  -- end

  -- use 'Shougo/ddc.vim'
  -- use 'Shougo/ddc-nvim-lsp'

  use 'MunifTanjim/nui.nvim'
  -- use 'nvim-neo-tree/neo-tree.nvim'

  use 'folke/noice.nvim'
  use {'rainbowhxch/accelerated-jk.nvim', config = function()
    vim.keymap.set('n', 'j', '<Plug>(accelerated_jk_gj)')
    vim.keymap.set('n', 'k', '<Plug>(accelerated_jk_gk)')
  end }

  -- use 'ggandor/leap.nvim'
  use 'tpope/vim-repeat'
  use 'rcarriga/nvim-notify'

  -- use {'TimUntersberger/neogit', commit = '4cc4476acbbc772f29fd6c1ccee43f58a29a1b13'}
  -- use 'sindrets/diffview.nvim'
  use 'lewis6991/gitsigns.nvim'

  -- operator & textobj
  use 'machakann/vim-sandwich'

  use {'kana/vim-niceblock', config = function()
    vim.keymap.set('x', 'I', '<Plug>(niceblock-I)')
    vim.keymap.set('x', 'A', '<Plug>(niceblock-A)')
  end }

  use 'akinsho/toggleterm.nvim'
  use 'gbprod/yanky.nvim'
  use 'gbprod/substitute.nvim'
end)
