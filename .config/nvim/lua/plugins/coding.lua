return {

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter, CmdlineEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    opts = function()
      local cmp = require("cmp")
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          -- { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        -- formatting = {
        --   format = function(_, item)
        --     local icons = require("lazyvim.config").icons.kinds
        --     if icons[item.kind] then
        --       item.kind = icons[item.kind] .. item.kind
        --     end
        --     return item
        --   end,
        -- },
        experimental = {
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
      }
    end,
  },

  -- auto pairs
  {
    "windwp/nvim-autopairs",
    config = true,
    event = "InsertEnter"
  },


  -- surround
  {
    "machakann/vim-sandwich",
  --   dependencies = {
  --     { 'machakann/vim-textobj-functioncall' },
  --     { 'kana/vim-textobj-entire' },
  --     { 'kana/vim-textobj-line' },
  --     { 'thinca/vim-textobj-between' },
  --     { 'yuki-yano/vim-textobj-cursor-context' },
  --   },
    event = { "ModeChanged" },
    keys = {
      { "si", "<Plug>(sandwich-add)i",           mode = { 'n', 'x' }, silent = true },
      { "sa", "<Plug>(sandwich-add)a",           mode = { 'n', 'x' }, silent = true },
      { "sD", "<Plug>(sandwich-delete)",         mode = { 'n', 'x' }, silent = true },
      { "sd", "<Plug>(sandwich-delete-auto)",    mode = { 'n', 'x' }, silent = true },
      { "sR", "<Plug>(sandwich-replace)",        mode = { 'n', 'x' }, silent = true },
      { "sr", "<Plug>(sandwich-replace-auto)",   mode = { 'n', 'x' }, silent = true },
      { "ib", "<Plug>(textobj-sandwich-auto-i)", mode = { 'o', 'x' }, silent = true },
      { "ab", "<Plug>(textobj-sandwich-auto-a)", mode = { 'o', 'x' }, silent = true },
    },
    init = function()
      vim.g.sandwich_no_default_key_mappings             = 1
      vim.g.textobj_functioncall_no_default_key_mappings = 1
    end,
    config = function()
      vim.fn["operator#sandwich#set"]('add', 'char', 'skip_space', 1)
      vim.g["sandwich#recipes"] = vim.deepcopy(vim.g["sandwich#default_recipes"])
    end,
  },

  -- comments
  {
    "numToStr/Comment.nvim",
    config = true,
    event = "VeryLazy",
    opts = {
      ---Add a space b/w comment and the line
      padding = true,
      ---Whether the cursor should stay at its position
      sticky = true,
      ---Lines to be ignored while (un)comment
      ignore = nil,
      ---LHS of toggle mappings in NORMAL mode
      toggler = {
          ---Line-comment toggle keymap
          line = 'gcc',
          ---Block-comment toggle keymap
          block = 'gbc',
      },
      ---LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
          ---Line-comment keymap
          line = 'gc',
          ---Block-comment keymap
          block = 'gb',
      },
      ---LHS of extra mappings
      extra = {
          ---Add comment on the line above
          above = 'gcO',
          ---Add comment on the line below
          below = 'gco',
          ---Add comment at the end of line
          eol = 'gcA',
      },
      ---Enable keybindings
      ---NOTE: If given `false` then the plugin won't create any mappings
      mappings = {
          ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
          basic = true,
          ---Extra mapping; `gco`, `gcO`, `gcA`
          extra = true,
          ---Extended mapping; `g>` `g<` `g>[count]{motion}` `g<[count]{motion}`
          extended = false,
      },
      ---Function to call before (un)comment
      pre_hook = nil,
      ---Function to call after (un)comment
      post_hook = nil,
    },
  },

  -- better text-objects

  -- edgemotion
  {
    'haya14busa/vim-edgemotion',
    keys = {
      { '<Leader>j', mode = { 'n', 'o', 'x' } },
      { '<Leader>k', mode = { 'n', 'o', 'x' } },
    },
    config = function()
      vim.keymap.set({ 'n' }, '<Leader>j', function()
        return 'm`' .. vim.fn['edgemotion#move'](1)
      end, { silent = true, expr = true })

      vim.keymap.set({ 'o', 'x' }, '<Leader>j', function()
        return vim.fn['edgemotion#move'](1)
      end, { silent = true, expr = true })

      vim.keymap.set({ 'n', 'o', 'x' }, '<Leader>k', function()
        return vim.fn['edgemotion#move'](0)
      end, { silent = true, expr = true })
    end,
  },

  -- accelerated jk
  {
    "rainbowhxch/accelerated-jk.nvim",
    keys = {
      { "j", "<Plug>(accelerated_jk_gj)", mode = "n" },
      { "k", "<Plug>(accelerated_jk_gk)", mode = "n" },
    },
  },

  -- better visual mode
  {
    "kana/vim-niceblock",
    keys = {
      { "I", "<Plug>(niceblock-I)", mode = "x" },
      { "A", "<Plug>(niceblock-A)", mode = "x" },
    },
  },

  { "gbprod/yanky.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = { "YankyClearHistory", "YankyRingHistory" },
    keys = {
      { mode = { "n", "x" }, "p", "<Plug>(YankyPutAfter)", desc = "yanky-put-after" },
      { mode = { "n", "x" }, "P", "<Plug>(YankyPutBefore)", desc = "yanky-put-before" },
      { mode = { "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", desc = "yanky-gput-after" },
      { mode = { "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", desc = "yanky-gput-before" },
      { mode = "n", "<leader>p", "<cmd>Telescope yank_history<CR>", desc = "yanky-history" },
    },
    opts = {
      highlight = {
        on_put = true,
        on_yank = true,
        timer = 420,
      },
      preserve_cursor_position = {
        enabled = true,
      },
    },
    config = function(_, opts)
      local yanky = require("yanky")

      vim.keymap.set('n', '<C-p>', function()
        if yanky.can_cycle() then
          return '<Plug>(YankyCycleForward)'
        else
          return '<C-p>'
        end
      end, { silent = true, expr = true })

      vim.keymap.set('n', '<C-n>', function()
        if yanky.can_cycle() then
          return '<Plug>(YankyCycleBackward)'
        else
          return '<C-n>'
        end
      end, { silent = true, expr = true })

      local function set_yanky_hl()
        vim.api.nvim_set_hl(0, "YankyPut", { link = "DiffAdd" })
        vim.api.nvim_set_hl(0, "YankyYanked", { link = "DiffChange" })
      end

      -- set_yanky_hl()
      -- require("pokerus.callback").colorscheme(set_yanky_hl)
      require("yanky").setup(opts)
      require("telescope").load_extension("yank_history")
    end
  },

  { "gbprod/substitute.nvim",
    dependencies = { "gbprod/yanky.nvim" },
    keys = {
      { mode = "n", "R", "<cmd>lua require('substitute').operator()<cr>", desc = "substitute" },
      { mode = "n", "ss", "<cmd>lua require('substitute').line()<cr>", desc = "substitute-line" },
      { mode = "n", "S", "<cmd>lua require('substitute').eol()<cr>", desc = "substitute-eol" },
      { mode = "x", "R", "<cmd>lua require('substitute').visual()<cr>", desc = "substitute" },
    },
    config = function()
      require("substitute").setup({
        on_substitute = require("yanky.integration").substitute(),
      })
    end,
  },
}
