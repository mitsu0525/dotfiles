return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "hrsh7th/cmp-nvim-lsp" },
      { 'SmiteshP/nvim-navic' },
    },
    keys = {
      { "(", vim.diagnostic.open_float, desc = "Line Diagnostics" },
    },
    ---@class PluginLspOpts
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        -- virtual_text = { spacing = 4, prefix = "●" },
        virtual_text = false,
        severity_sort = true,
      },
      -- Automatically format on save
      autoformat = true,
      -- Enable this to show formatters used in a notification
      -- Useful for debugging formatter issues
      format_notify = false,
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        -- jsonls = {},
        lua_ls = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    ---@param opts PluginLspOpts
    config = function(plugin, opts)
      local Util = require("util")
      -- setup autoformat
      require("plugins.lsp.format").setup(opts)
      -- setup formatting and keymaps
      Util.on_attach(function(client, buffer)
        require("plugins.lsp.keymaps").on_attach(client, buffer)
      end)

      -- diagnostics
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      -- for name, icon in pairs(require("lazyvim.config").icons.diagnostics) do
      for name, icon in pairs(signs) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      vim.diagnostic.config(opts.diagnostics)

      local servers = opts.servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- temp fix for lspconfig rename
      -- https://github.com/neovim/nvim-lspconfig/pull/2439
      local mappings = require("mason-lspconfig.mappings.server")
      if not mappings.lspconfig_to_package.lua_ls then
        mappings.lspconfig_to_package.lua_ls = "lua-language-server"
        mappings.package_to_lspconfig["lua-language-server"] = "lua_ls"
      end

      local mlsp = require("mason-lspconfig")
      local available = mlsp.get_available_servers()

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(available, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      require("mason-lspconfig").setup({ ensure_installed = ensure_installed })
      require("mason-lspconfig").setup_handlers({ setup })
    end,
  },

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    -- dependencies = { "williamboman/mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.black,
          nls.builtins.diagnostics.flake8,
        },
      }
    end,
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(plugin, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },

  {
      "glepnir/lspsaga.nvim",
      event = "LspAttach",
      dependencies = {
        {"nvim-tree/nvim-web-devicons"},
        --Please make sure you install markdown and markdown_inline parser
        {"nvim-treesitter/nvim-treesitter"}
      },
      config = function()
          require("lspsaga").setup({
            ui = {
              theme = 'round',
              border = 'rounded',
              title = false,
              -- winblend = 0,
              -- expand = '>',
              -- collapse = 'v',
              -- preview = '< ',
              -- hover = diagnostic_icons.hint,
              -- code_action = lsp_icons.code_action,
              -- diagnostic = lsp_icons.diagnostic,
              -- incoming = lsp_icons.incoming,
              -- outgoing = lsp_icons.outgoing,
              -- -- NOTE: from: `require('catppuccin.groups.integrations.lsp_saga').custom_colors()`
              -- colors = {
              --   normal_bg = color.base().black,
              --   title_bg = color.base().green,
              --   black = color.base().empty,
              --   white = color.base().white, -- TODO: change to text
              --   red = color.base().red,
              --   blue = color.base().blue,
              --   green = color.base().green,
              --   yellow = color.base().yellow,
              --   cyan = color.base().cyan, -- TODO: change to sky
              --   magenta = color.base().magenta, -- TODO: change to maroon
              --   orange = color.base().orange,
              --   purple = color.base().purple,
              -- },
            },
          })
          vim.keymap.set({ 'n' }, 'K', function()
            local ft = vim.o.filetype
            if ft == 'vim' or ft == 'help' then
              vim.cmd([[execute 'h ' . expand('<cword>') ]])
            else
              vim.cmd([[Lspsaga hover_doc]])
            end
          end)
      end,
  },

}
