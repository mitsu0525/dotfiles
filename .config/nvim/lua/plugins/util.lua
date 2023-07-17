return {
  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },

  {
    "tyru/capture.vim",
    cmd = { "Capture" },
    config = function()
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "Capture" },
        callback = function()
          vim.keymap.set({ "n" }, "q", "<Cmd>quit<CR>", { buffer = true, nowait = true })
        end,
      })
    end,
  },

  {
    "thinca/vim-quickrun",
    dependencies = {
      { "lambdalisue/vim-quickrun-neovim-job" },
    },
  },

  {
    "uga-rosa/ccc.nvim",
    event = { "BufRead", "BufNewFile" },
    keys = {
      { mode = "n", "<leader>c", "<cmd>CccPick<cr>", desc = "Toggle colorizer" },
    },
    opts = {
      highlighter = {
        auto_enable = true,
      },
    },
  },
}
