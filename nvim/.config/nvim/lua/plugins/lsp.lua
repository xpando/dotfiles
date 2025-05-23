return {
  {
    'williamboman/mason.nvim',

    dependencies = {
      { 
        -- Automatically configures lua-language-server for your Neovim config, Neovim runtime and plugin directories 
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      },
      'neovim/nvim-lspconfig',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim', -- Automatically install linters, formatters and debug adapters
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
      'nvimtools/none-ls.nvim',
    },

    config = function()
      -- Automatically install these servers
      local servers = {
				pyright = {},
        ruff = {},
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
          'shfmt',

          -- Linters
          'shellcheck',
					'pyright',

          -- Debug adapters
        },
      }

      require('dapui').setup()

      local null_ls = require 'null-ls'
      null_ls.setup {
        sources = {
          null_ls.builtins.formatting.stylua,
        },
      }

    end,
  },
}
