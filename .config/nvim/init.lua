--MANAGER
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

----GENERAL SETTINGS
local opt = vim.opt

--CHAR
opt.encoding = "utf-8"
opt.fileencodings = {"utf-8", "iso-2022-jp", "cp932", "euc-jp", "sjis"}

--DISPLAY
opt.termguicolors = true
opt.cmdheight = 0
opt.cursorline = true
opt.showcmd = true
opt.list = true
opt.listchars = {tab="▸-", trail="-", eol="↲", extends="»", precedes="«", nbsp="%"}
opt.laststatus = 3
opt.hidden = true

--HELP
opt.helplang = "ja", "en"

--TAB/INDENT
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.autoindent = true
opt.smartindent = true
opt.shiftwidth = 2

--SEARCH
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.wrapscan = true

--SWAP/BACKUP
--opt.nowritebackup = true
opt.writebackup = false
opt.backup = false
opt.swapfile = false

--CURSOR
opt.backspace:append{"indent", "eol", "start"}
-- set whichwrap=b,s,h,l,<,>,[,]
opt.startofline = false

--BRACKET/TAG JUMP
opt.showmatch = true

--COMMAND COMPLETION
opt.wildmenu = true

--MOUSE
opt.mouse = ""

--CLIPBOARD
local in_wsl = os.getenv("WSL_DISTRO_NAME") ~= nil
if in_wsl then
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf"
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf"
    },
    cache_enable = 0,
  }
end
opt.clipboard:append{"unnamedplus"}
-- opt.clipboard:append "unnamedplus"
-- vim.opt.shortmess:append("c")

-- opt.wrap = true
-- opt.signcolumn = 'yes'
-- opt.matchtime = 1
-- opt.guicursor = ''
-- opt.autoread = true
-- opt.showtabline = 1
-- opt.ambiwidth = 'single'
-- opt.confirm = true
-- opt.pumblend = 15
-- opt.winblend = 15
-- opt.timeout = true
-- opt.ttimeout = true
-- opt.ttimeoutlen = 10
-- opt.showmode = false
-- opt.completeopt:append{'menuone', 'noinsert'}
-- vim.opt.shortmess:append('I')
--
-- vim.cmd('set completeopt-=preview')
--
--
-- ----ADVANCED SETTINGS
--
-- --KEEP CURSOR
-- vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
--     pattern = { '*' },
--     callback = function()
--         vim.api.nvim_exec('silent! normal! g`"zv', false)
--     end,
-- })


----KEY MAPPING
--local function map(mode, lhs, rhs, opts)
--  local keys = require("lazy.core.handler").handlers.keys
--  ---@cast keys LazyKeysHandler
--  -- do not create the keymap if a lazy keys handler exists
--  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
--    vim.keymap.set(mode, lhs, rhs, opts)
--  end
--end
local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent == nil and true or opts.silent
	vim.keymap.set(mode, lhs, rhs, opts)
end
vim.g.mapleader = " "
--vim.g.mapleader = escape("<Space>")

--COMMAND LINE
map("n", "<leader><Space>", ":")
map("n", "<C-a>", "<Home>")
map("n", "<C-b>", "<Left>")
map("n", "<C-d>", "<Del>")
map("n", "<C-e>", "<End>")
map("n", "<C-f>", "<Right>")
map("n", "<C-n>", "<Down>")
map("n", "<C-p>", "<Up>")
map("n", "<C-q>", "<C-c>")
--ESC
map("i", "jj", "<ESC>")
map("i", "j<Space>", "j")
-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

--EDIT
map("n", "<leader>w", ":<C-u>w<CR>")
map("n", "<leader>q", ":<C-u>qa<CR>")
map("n", "<leader>Q", ":<C-u>q!<CR>")

map("n", "sg", ":<C-u>%s//g<Left><Left>")
map("x", "sg", ":s//g<Left><Left>")

-- better indenting
map("n", ">", ">>")
map("n", "<", "<<")
map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "Y", "y$")

map("n", "<CR>", ":<C-u>call append(line('.'), '')<CR><Down>", {silent = true})

--BUFFER
map("n", "<C-l>", ":<C-u>bnext<CR>", {silent = true})
map("n", "<C-h>", ":<C-u>bprev<CR>", {silent = true})
map("n", "<C-q>", ":<C-u>bdelete<CR>", {silent = true})

--SPLIT
map("n", "sv", ":<C-u>vsplit<CR>", {silent = true})
map("n", "sp", ":<C-u>split<CR>", {silent =true})
map("n", "so", ":<C-u>only<CR>", {silent =true})
map("n", "<Tab>", ":wincmd w<CR>", {silent =true})

--NOP
map("n", "<MiddleMouse>", "<Nop>")
map("n", "<2-MiddleMouse>", "<Nop>")
map("n", "<3-MiddleMouse>", "<Nop>")
map("n", "<4-MiddleMouse>", "<Nop>")
map("i", "<1-MiddleMouse>", "<Nop>")
map("i", "<2-MiddleMouse>", "<Nop>")
map("i", "<3-MiddleMouse>", "<Nop>")
map("i", "<4-MiddleMouse>", "<Nop>")
map("n", "ZZ", "<Nop>")
map("n", "ZQ", "<Nop>")
map("n", "<C-z>", "<Nop>")
map("n", "<F1>", "<Nop>")
map("n", "x", '"_x')
map("v", "x", '"_x')
map("n", "s", '"_s')

--MOVE
-- better up/down
map("n", "<C-j>", "max([winheight(0) - 2, 1]) . '<C-d>' . (line('w$') >= line('$') ? 'L' : 'M')", { expr = true, silent = true })
map("n", "<C-k>", "max([winheight(0) - 2, 1]) . '<C-u>' . (line('w0') <= 1 ? 'H' : 'M')", { expr = true, silent = true })
map("n", "<leader>h", "^")
map("n", "<leader>l", "$")
map("n", "H", "^")
map("n", "L", "$")

--COPY
-- vim.keymap.set('n', 'p', ']p')
-- vim.keymap.set('n', 'P', ']P')
-- vim.keymap.set('n', ']p', 'p')
-- vim.keymap.set('n', ']P', 'P')

----PLUGINS


-- require("lazy").setup(plugins, opts)
require("lazy").setup({ 
defaults = {lazy = true},
{"nvim-lualine/lualine.nvim", event = "VeryLazy"},
{"nvim-telescope/telescope.nvim", cmd = "Telescope"},
{"nvim-telescope/telescope-file-browser.nvim", event = "VeryLazy"},
{"lewis6991/gitsigns.nvim", config = true, event = "BufNewFile, BufRead"},
-- {"ryanoasis/vim-devicons", event = "VeryLazy"},
{"nvim-tree/nvim-web-devicons", event = "VeryLazy"},
{"williamboman/mason.nvim", event = "BufRead", cmd = {"Mason", "MasonInstall"},},
{"neovim/nvim-lspconfig", event = "LspAttach"},
-- {"williamboman/mason-lspconfig.nvim", event = "LspAttach"},
-- {"jay-babu/mason-null-ls.nvim", evtnt = "BufRead", cmd = {"NullInstall", "NullUninstall"},},
-- {"jose-elias-alvarez/null-ls.nvim", event = "LspAttach"},
-- {"j-hui/fidget.nvim", config = true, event = "LspAttach"},
-- {"sainnhe/edge", event = "VeryLazy"},
{"folke/tokyonight.nvim", event = "VeryLazy"},
{"nvim-lua/plenary.nvim", event = "VeryLazy"},
{"stevearc/dressing.nvim", event = "VeryLazy"},
{"hrsh7th/nvim-cmp", event = "InsertEnter, CmdlineEnter"},
{"hrsh7th/cmp-nvim-lsp", event = "InsertEnter"}, 
{"hrsh7th/cmp-buffer", event = "InsertEnter"},
{"hrsh7th/cmp-path", event = "InsertEnter"},
{"hrsh7th/cmp-vsnip", event = "InsertEnter"},
{"hrsh7th/cmp-cmdline", event = "ModeChanged"},
-- {"hrsh7th/cmp-nvim-lsp-signature-help", event = "InsertEnter"},
-- {"hrsh7th/cmp-nvim-lsp-document-symbol", event = "InsertEnter"},
-- {"hrsh7th/cmp-calc", event = "InsertEnter"},
{"onsails/lspkind.nvim", event = "InsertEnter"},
{"hrsh7th/vim-vsnip", event = "InsertEnter"},
-- {"hrsh7th/vim-vsnip-integ", event = "InsertEnter"},
-- {"rafamadriz/friendly-snippets", event = "InsertEnter"},
{"nvim-treesitter/nvim-treesitter", event = "BufNewFile, BufRead"},
-- {"yioneko/nvim-yati", event = "VeryLazy"},
{"windwp/nvim-autopairs", config = true, event = "InsertEnter"},
-- {"andymass/vim-matchup", event = "VeryLazy"},
-- {"Maan2003/lsp_lines.nvim", config = true, event = "BufNewFile, BufRead"},
-- {"lambdalisue/suda.vim", cmd = {"SudaWrite", "SudaRead"},},
-- {"norcalli/nvim-colorizer.lua", event = "BufNewFile, BufRead"},
-- {"lukas-reineke/indent-blankline.nvim", event = "BufNewFile, BufRead"},
-- {"kevinhwang91/nvim-hlslens", event = "BufNewFile, BufRead"},
{"numToStr/Comment.nvim", config = true, event = "VeryLazy"},
-- {"rhysd/clever-f.vim", event = "VeryLazy"},
-- {"luochen1990/rainbow", event = "BufNewFile, BufRead"},
-- {"echasnovski/mini.surround", event = "ModeChanged"},
-- {"echasnovski/mini.ai", event = "ModeChanged"},
-- {"mvllow/modes.nvim", event = "BufNewFile, BufRead"},
-- {"monaqa/dial.nvim", event = "VeryLazy"},
{"tpope/vim-repeat", event = "VeryLazy"},
-- {"petertriho/nvim-scrollbar", event = "BufNewFile, BufRead"},
-- {"dstein64/vim-startuptime", cmd = "StartupTime"},
-- {"vim-jp/vimdoc-ja", ft = "help"},

--non-lazy
-- {'vim-denops/denops.vim', lazy = false},
-- {'yuki-yano/fuzzy-motion.vim', lazy = false},
-- {'lambdalisue/gin.vim', lazy = false},
-- {'rbtnn/vim-ambiwidth', lazy = false},
-- {'lambdalisue/kensaku-search.vim', lazy = false},
-- {'lambdalisue/kensaku.vim', lazy = false},

--disable default plugins
  performance = {
    rtp = {
      disable_plugins = {
        'netrw',
        'netrwPlugin',
        'netrwSettings',
        'netrwFileHandlers',
        'gzip',
        'zip',
        'zipPlugin',
        'tar',
        'tarPlugin',
        'getscript',
        'getscriptPlugin',
        'vimball',
        'vimballPlugin',
        '2html_plugin',
        'logipat',
        'rrhelper',
        'spellfile_plugin',
        'sql_completion',
      },
    },
  },
})


----lualine
--require('lualine').setup {
--  options = {
--    icons_enabled = true,
--    theme = 'tokyonight',
--    section_separators = { left = '', right = '' },
--    component_separators = { left = '|', right = '|' },
--    disabled_filetypes = {}
--  },
--  sections = {
--    lualine_a = { 'mode' },
--    lualine_b = { 'branch' },
--    lualine_c = { {
--      'filename',
--      file_status = true, -- displays file status (readonly status, modified status)
--      path = 0 -- 0 = just filename, 1 = relative path, 2 = absolute path
--    } },
--    lualine_x = {
--      { 'diagnostics', sources = { "nvim_diagnostic" }, symbols = { error = ' ', warn = ' ', info = ' ',
--        hint = ' ' } },
--      'encoding',
--      'filetype'
--    },
--    lualine_y = { 'progress' },
--    lualine_z = { 'location' }
--  },
--  inactive_sections = {
--    lualine_a = {},
--    lualine_b = {},
--    lualine_c = { {
--      'filename',
--      file_status = true, -- displays file status (readonly status, modified status)
--      path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
--    } },
--    lualine_x = { 'location' },
--    lualine_y = {},
--    lualine_z = {}
--  },
--  tabline = {},
--  extensions = { 'fugitive' }
--}
--
--
----telescope
--local status, telescope = pcall(require, "telescope")
--if (not status) then return end
--local actions = require('telescope.actions')
--local builtin = require("telescope.builtin")
--
--local function telescope_buffer_dir()
--  return vim.fn.expand('%:p:h')
--end
--
--local fb_actions = require "telescope".extensions.file_browser.actions
--
--telescope.setup {
--  defaults = {
--    mappings = {
--      n = {
--        ["q"] = actions.close,
--          ["l"] = actions.select_default,
--      },
--      i = {
--        ["<CR>"] = { "<esc>", type = "command" },
--      }
--    },
--    initial_mode = "normal",
--  },
--  extensions = {
--    file_browser = {
--      theme = "dropdown",
--      initial_mode = "normal",
--      -- disables netrw and use telescope-file-browser in its place
--      hijack_netrw = true,
--      mappings = {
--        -- your custom insert mode mappings
--        ["i"] = {
--          ["<C-w>"] = function() vim.cmd('normal vbd') end,
--        },
--        ["n"] = {
--          -- your custom normal mode mappings
--          ["N"] = fb_actions.create,
--          ["h"] = fb_actions.goto_parent_dir,
--          ["l"] = actions.select_default,
--          ["/"] = function()
--            vim.cmd('startinsert')
--          end
--        },
--      },
--    },
--    frecency = {
--      initial_mode = "insert",
--      show_scores = false,
--      show_unindexed = true,
--      ignore_patterns = {"*.git/*", "*/tmp/*"},
--      disable_devicons = false,
--      -- workspaces = {
--      --   ["conf"]    = "/home/my_username/.config",
--      --   ["data"]    = "/home/my_username/.local/share",
--      --   ["project"] = "/home/my_username/projects",
--      --   ["wiki"]    = "/home/my_username/wiki"
--      },
--    },
--  }
--
--telescope.load_extension("file_browser")
--telescope.load_extension("frecency")
---- telescope.load_extension('smart_history')
--
--vim.api.nvim_set_keymap("n", "-f",
--"<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
--{noremap = true, silent = true})
--
---- vim.keymap.set('n', ';f',
----   function()
----     builtin.find_files({
----       no_ignore = false,
----       hidden = true
----     })
----   end)
---- vim.keymap.set('n', ';r', function()
----   builtin.live_grep()
---- end)
---- vim.keymap.set('n', '\\\\', function()
----   builtin.buffers()
---- end)
---- vim.keymap.set('n', ';t', function()
----   builtin.help_tags()
---- end)
--vim.keymap.set('n', ';;', function()
--  builtin.resume()
--end)
---- vim.keymap.set('n', ';e', function()
----   builtin.diagnostics()
---- end)
--vim.keymap.set("n", ";o", function()
--  telescope.extensions.file_browser.file_browser({
--    path = "%:p:h",
--    cwd = telescope_buffer_dir(),
--    respect_gitignore = false,
--    hidden = true,
--    grouped = true,
--    --previewer = false,
--    initial_mode = "normal",
--    layout_config = { height = 40 }
--  })
--end)
--
--vim.keymap.set("n", "<leader>o", function()
--  telescope.extensions.file_browser.file_browser({
--    path = "%:p:h",
--    cwd = telescope_buffer_dir(),
--    respect_gitignore = false,
--    hidden = true,
--    grouped = true,
--    previewer = false,
--    initial_mode = "normal",
--    layout_config = { height = 40 }
--  })
--
--  local status, tokyonight = pcall(require, "tokyonight")
--  if (not status) then return end
--
--  tokyonight.setup({
--    -- your configuration comes here
--    -- or leave it empty to use the default settings
--    style = "moon", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
--    light_style = "day", -- The theme is used when the background is set to light
--    transparent = true, -- Enable this to disable setting the background color
--    terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
--    styles = {
--      -- Style to be applied to different syntax groups
--      -- Value is any valid attr-list value for `:help nvim_set_hl`
--      comments = { italic = true },
--      keywords = { italic = true },
--      functions = {},
--      variables = {},
--      -- Background styles. Can be "dark", "transparent" or "normal"
--      sidebars = "dark", -- style for sidebars, see below
--      floats = "transparent", -- style for floating windows
--    },
--    sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
--    day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
--    hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
--    dim_inactive = false, -- dims inactive windows
--    lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
--
--    --- You can override specific color groups to use other groups or a hex color
--    --- function will be called with a ColorScheme table
--    ---@param colors ColorScheme
--    on_colors = function(colors) end,
--
--    --- You can override specific highlights to use other groups or a hex color
--    --- function will be called with a Highlights and ColorScheme table
--    ---@param highlights Highlights
--    ---@param colors ColorScheme
--    on_highlights = function(highlights, colors) end,
--  })
--end)
--
--vim.cmd("colorscheme tokyonight")
