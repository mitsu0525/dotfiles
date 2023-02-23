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
}
