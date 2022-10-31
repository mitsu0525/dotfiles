local status, telescope = pcall(require, "telescope")
if (not status) then return end
local actions = require('telescope.actions')
local builtin = require("telescope.builtin")

local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

-- vim.g.sqlite_clib_path = "C://Users/55330/bin/sqlite3.dll"
local fb_actions = require "telescope".extensions.file_browser.actions

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close,
          ["l"] = actions.select_default,
      },
      i = {
        ["<CR>"] = { "<esc>", type = "command" },
      }
    },
    -- history = {
    --   path = 'C://Users/55330/.config/nvim/telescope_history.sqlite3',
    --   limit = 100,
    -- },
    initial_mode = "normal",
  },
  extensions = {
    file_browser = {
      theme = "dropdown",
      initial_mode = "normal",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        -- your custom insert mode mappings
        ["i"] = {
          ["<C-w>"] = function() vim.cmd('normal vbd') end,
        },
        ["n"] = {
          -- your custom normal mode mappings
          ["N"] = fb_actions.create,
          ["h"] = fb_actions.goto_parent_dir,
          ["l"] = actions.select_default,
          ["/"] = function()
            vim.cmd('startinsert')
          end
        },
      },
    },
    frecency = {
      initial_mode = "insert",
      show_scores = false,
      show_unindexed = true,
      ignore_patterns = {"*.git/*", "*/tmp/*"},
      disable_devicons = false,
      -- workspaces = {
      --   ["conf"]    = "/home/my_username/.config",
      --   ["data"]    = "/home/my_username/.local/share",
      --   ["project"] = "/home/my_username/projects",
      --   ["wiki"]    = "/home/my_username/wiki"
    },
  },
}

telescope.load_extension("file_browser")
telescope.load_extension("frecency")
-- telescope.load_extension('smart_history')

vim.api.nvim_set_keymap("n", "-f",
"<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
{noremap = true, silent = true})

-- vim.keymap.set('n', ';f',
--   function()
--     builtin.find_files({
--       no_ignore = false,
--       hidden = true
--     })
--   end)
-- vim.keymap.set('n', ';r', function()
--   builtin.live_grep()
-- end)
-- vim.keymap.set('n', '\\\\', function()
--   builtin.buffers()
-- end)
-- vim.keymap.set('n', ';t', function()
--   builtin.help_tags()
-- end)
vim.keymap.set('n', ';;', function()
  builtin.resume()
end)
-- vim.keymap.set('n', ';e', function()
--   builtin.diagnostics()
-- end)
vim.keymap.set("n", ";o", function()
  telescope.extensions.file_browser.file_browser({
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    --previewer = false,
    initial_mode = "normal",
    layout_config = { height = 40 }
  })
end)

vim.keymap.set("n", "[Space]o", function()
  telescope.extensions.file_browser.file_browser({
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    --previewer = false,
    initial_mode = "normal",
    layout_config = { height = 40 }
  })
end)
