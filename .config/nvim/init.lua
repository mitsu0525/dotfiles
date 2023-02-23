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
opt.listchars = {tab="▸-", trail="-", extends="»", precedes="«", nbsp="%"}
opt.laststatus = 3
opt.hidden = true
opt.wrap = false

--HELP
opt.helplang = {"ja", "en"}

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
-- opt.clipboard:append{"unnamedplus"}
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
map("n", "<leader><Space>", ":", {silent = false})
map("c", "<C-a>", "<Home>")
map("c", "<C-b>", "<Left>")
map("c", "<C-d>", "<Del>")
map("c", "<C-e>", "<End>")
map("c", "<C-f>", "<Right>")
map("c", "<C-n>", "<Down>")
map("c", "<C-p>", "<Up>")
map("c", "<C-q>", "<C-c>")
--ESC
map("i", "jj", "<ESC>")
map("i", "j<Space>", "j")
-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

--EDIT
map("n", "<leader>w", ":<C-u>w<CR>")
map("n", "<leader>q", ":<C-u>qa<CR>")
map("n", "<leader>Q", ":<C-u>q!<CR>")

map("n", "sg", ":<C-u>%s//g<Left><Left>", {silent = false})
map("x", "sg", ":s//g<Left><Left>", {silent = false})

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
map("n", "sp", ":<C-u>split<CR>", {silent = true})
map("n", "so", ":<C-u>only<CR>", {silent = true})
map("n", "<Tab>", ":wincmd w<CR>", {silent =true})
map("n", "Q", "winnr('$') != 1 ? ':<C-u>close<CR>' : ''", { expr = true, silent = true })

--NOP
-- map("n", "<MiddleMouse>", "<Nop>")
-- map("i", "<1-MiddleMouse>", "<Nop>")
-- map({"i", "n"}, "<2-MiddleMouse>", "<Nop>")
-- map({"i", "n"}, "<3-MiddleMouse>", "<Nop>")
-- map({"i", "n"}, "<4-MiddleMouse>", "<Nop>")
map("n", "ZZ", "<Nop>")
map("n", "ZQ", "<Nop>")
map("n", "<C-z>", "<Nop>")
map("n", "<F1>", "<Nop>")
map({"n", "x"}, "x", '"_x')
map("n", "s", '"_s')

--MOVE
-- better up/down
map({"n", "x"}, "<C-j>", "max([winheight(0)-2, 1]) . '<C-d>' . (line('w$') >= line('$') ? 'L' : 'M')", { expr = true, silent = true })
map({"n", "x"}, "<C-k>", "max([winheight(0)-2, 1]) . '<C-u>' . (line('w0') <= 1 ? 'H' : 'M')", { expr = true, silent = true })
map({"n", "x"}, "<leader>h", "^")
map({"n", "x"}, "<leader>l", "$")
-- map("n", "H", "^")
-- map("n", "L", "$")

--COPY
-- vim.keymap.set('n', 'p', ']p')
-- vim.keymap.set('n', 'P', ']P')
-- vim.keymap.set('n', ']p', 'p')
-- vim.keymap.set('n', ']P', 'P')

----PLUGINS

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
require("lazy").setup("plugins")

vim.cmd("colorscheme tokyonight")
