return {
  {
    'williamboman/mason.nvim',

    dependencies = {
      'folke/neodev.nvim', -- Automatically configures lua-language-server for your Neovim config, Neovim runtime and plugin directories
      'neovim/nvim-lspconfig',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim', -- Automatically install linters, formatters and debug adapters
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
      'nvimtools/none-ls.nvim',
    },

    config = function()
      -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
      require('neodev').setup {
        library = { plugins = { 'neotest' }, types = true },
      }

      -- Automatically install these servers
      local servers = {
        html = { filetypes = { 'html', 'htm' } },
        ts_ls = {},
        jsonls = {},
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      }

      local mason = require 'mason'
      mason.setup {
        ui = {
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
        },
      }

      local mason_lspconfig = require 'mason-lspconfig'
      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      }

      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
          }
        end,
      }

      -- Automatically install these linters, formatters and debug adapters
      require('mason-tool-installer').setup {
        ensure_installed = {
          -- Formatters
          'prettierd',
          'shfmt',

          -- Linters
          'shellcheck',
          'eslint_d',

          -- Debug adapters
          'js-debug-adapter',
          'chrome-debug-adapter',
          'firefox-debug-adapter',
        },
      }

      require('dapui').setup()

      local null_ls = require 'null-ls'
      null_ls.setup {
        sources = {
          null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.google_java_format,
					null_ls.builtins.formatting.ktlint,
          null_ls.builtins.formatting.prettierd,
          null_ls.builtins.diagnostics.eslint_d,
        },
      }

    end,
  },
}
