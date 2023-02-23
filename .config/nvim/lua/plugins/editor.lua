return {

  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    keys = {
      { ";;", function() require("telescope.builtin").resume() end, mode = "n"},
      { ";f", "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>", mode = "n", noremap = true, silent = true},
      { ";o",
        function()
          require("telescope").extensions.file_browser.file_browser({
            path = "%:p:h",
            cwd = vim.fn.expand('%:p:h'),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            --previewer = false,
            initial_mode = "normal",
            layout_config = { height = 40 }
          })
        end,
        mode = "n",
      },
      { "<leader>o",
        function()
          require("telescope").extensions.file_browser.file_browser({
            path = "%:p:h",
            cwd = vim.fn.expand('%:p:h'),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = false,
            initial_mode = "normal",
            layout_config = { height = 40 }
          })
        end,
        mode = "n",
      },
    },
    -- opts = {
    config = function()
      local status, telescope = pcall(require, "telescope")
      local actions = require('telescope.actions')
      local builtin = require("telescope.builtin")

      local function telescope_buffer_dir()
        return vim.fn.expand('%:p:h')
      end

      local fb_actions = require "telescope".extensions.file_browser.actions

      telescope.setup({
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
                end,
              },
            },
          },
        },
      })
      telescope.load_extension("file_browser")
    end,
    -- },
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    event = "VeryLazy"
  },

  {
    "nvim-telescope/telescope-frecency.nvim",
    event = "VeryLazy"
  },

-- git signs
--  {
--    "lewis6991/gitsigns.nvim",
--    event = { "BufReadPre", "BufNewFile" },
--    opts = {
--      signs = {
--        add = { text = "▎" },
--        change = { text = "▎" },
--        delete = { text = "契" },
--        topdelete = { text = "契" },
--        changedelete = { text = "▎" },
--        untracked = { text = "▎" },
--      },
--      on_attach = function(buffer)
--        local gs = package.loaded.gitsigns
--
--        local function map(mode, l, r, desc)
--          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
--        end
--
--        -- stylua: ignore start
--        map("n", "]h", gs.next_hunk, "Next Hunk")
--        map("n", "[h", gs.prev_hunk, "Prev Hunk")
--        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
--        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
--        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
--        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
--        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
--        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
--        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
--        map("n", "<leader>ghd", gs.diffthis, "Diff This")
--        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
--        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
--      end,
--    },
--  },
}
