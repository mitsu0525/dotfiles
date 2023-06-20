return {

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      'hrsh7th/vim-vsnip-integ',
      'onsails/lspkind.nvim',
    },
    event = "InsertEnter, CmdlineEnter",
    opts = function()
      local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end

      local cmp = require("cmp")
      local lspkind = require('lspkind')

      return {
        window = {
          -- completion = cmp.config.window.bordered({
          --   border = 'single'
          -- }),
          documentation = cmp.config.window.bordered({
            border = 'single'
          }),
        },
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_selected_entry() then
              cmp.confirm({ select = true })
            else
              fallback()
            end
          end),
          ['<Tab>'] = cmp.mapping(function(fallback)
            -- if cmp.visible() and cmp.get_selected_entry() then
            --   cmp.confirm({ select = true })
            if vim.fn["vsnip#available"]() == 1 then
              feedkey("<Plug>(vsnip-expand-or-jump)", "")
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if vim.fn["vsnip#jumpable"](-1) == 1 then
              feedkey("<Plug>(vsnip-jump-prev)", "")
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "vsnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = 50,
            ellipsis_char = '...',
          })
        },
        experimental = {
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
      }
    end,
  },

  {
    'hrsh7th/cmp-vsnip',
    event = 'InsertEnter'
  },

  {
    'hrsh7th/vim-vsnip',
    event = 'InsertEnter',
    init = function()
      vim.g.vsnip_snippet_dir = vim.fn.expand("~/.config/nvim/vsnip")
      vim.g.vsnip_filetypes = {
        typescript = { 'javascript' },
        typescriptreact = { 'javascript' },
        javascriptreact = { 'javascript' },
      }
    end,
  },

  {
    'hrsh7th/vim-vsnip-integ',
    event = 'InsertEnter'
  },

  {
    'onsails/lspkind.nvim',
    event = 'InsertEnter'
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

  {
    "gbprod/yanky.nvim",
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

  {
    "gbprod/substitute.nvim",
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

  {
    "hrsh7th/nvim-insx",
    event = {"InsertEnter"},
    config = function(_, opts)
      require('insx.preset.standard').setup()
      local insx = require('insx')
      local fast_wrap = require('insx.recipe.fast_wrap')

      for open, close in pairs({ ["("] = ")", ["["] = "]", ["{"] = "}" }) do
        -- fast wrap
        insx.add('<C-w>', insx.with(fast_wrap({ close = close }), { insx.with.undopoint() }))
      end
    end,
  },

  -- better text-objects
  { 'kana/vim-textobj-user' },

  {
    'kana/vim-textobj-entire',
    dependencies = {
      { 'kana/vim-textobj-user' },
    },
    event = { 'ModeChanged' },
    init = function()
      vim.g.textobj_entire_no_default_key_mappings = true

      vim.keymap.set({ 'o', 'x' }, 'ie', '<Plug>(textobj-entire-i)')
      vim.keymap.set({ 'o', 'x' }, 'ae', '<Plug>(textobj-entire-a)')
    end,
  },

  {
    'kana/vim-textobj-line',
    dependencies = {
      { 'kana/vim-textobj-user' },
    },
    event = { 'ModeChanged' },
    init = function()
      vim.g.textobj_line_no_default_key_mappings = true

      vim.keymap.set({ 'o', 'x' }, 'il', '<Plug>(textobj-line-i)')
      vim.keymap.set({ 'o', 'x' }, 'al', '<Plug>(textobj-line-a)')
    end,
  },

  -- better increase/descrease
  {
    "monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
        },
      })
    end,
  },
}
