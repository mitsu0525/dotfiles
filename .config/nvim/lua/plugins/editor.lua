return {

  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      {
        ";;",
        function()
          require("telescope.builtin").resume()
        end,
        mode = "n",
      },
      {
        ";g",
        function()
          require("telescope.builtin").live_grep()
        end,
        mode = "n",
      },
      {
        ";h",
        function()
          require("telescope.builtin").help_tags()
        end,
        mode = "n",
      },
      {
        ";m",
        "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
        mode = "n",
        noremap = true,
        silent = true,
      },
      {
        "<leader>o",
        "<Cmd>lua require('telescope').extensions.file_browser.file_browser()<CR>",
        mode = "n",
        noremap = true,
        silent = true,
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions

      telescope.setup({
        defaults = {
          mappings = {
            n = {
              ["q"] = actions.close,
              ["l"] = actions.select_default,
            },
            i = {
              ["<CR>"] = { "<esc>", type = "command" },
            },
          },
          initial_mode = "normal",
        },
        extensions = {
          file_browser = {
            path = "%:p:h",
            cwd = vim.fn.expand("%:p:h"),
            theme = "dropdown",
            previewer = false,
            hijack_netrw = true, -- disables netrw and use telescope-file-browser in its place
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            layout_config = { height = 40 },
            mappings = {
              -- your custom insert mode mappings
              ["i"] = {
                ["<C-w>"] = function()
                  vim.cmd("normal vbd")
                end,
              },
              ["n"] = {
                -- your custom normal mode mappings
                ["N"] = fb_actions.create,
                ["h"] = fb_actions.goto_parent_dir,
                ["l"] = actions.select_default,
                ["/"] = function()
                  vim.cmd("startinsert")
                end,
              },
            },
          },
          frecency = {
            db_root = "~/.local/share/nvim",
            show_scores = false,
            show_unindexed = true,
            ignore_patterns = { "*.git/*", "*/tmp/*" },
            disable_devicons = false,
            -- workspaces = {
            --   ["conf"]    = "/home/my_username/.config",
            --   ["data"]    = "/home/my_username/.local/share",
            --   ["project"] = "/home/my_username/projects",
            --   ["wiki"]    = "/home/my_username/wiki"
          },
        },
      })
      require("telescope").load_extension("file_browser")
    end,
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },

  {
    "nvim-telescope/telescope-frecency.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension("frecency")
    end,
  },

  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        -- delete = { text = "契" },
        -- topdelete = { text = "契" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
}
