-- local vue_language_server_path = vim.fn.stdpath('data')
--   .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'

return {
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'stylua',
        'luacheck',
        'html-lsp',
        'css-lsp',
        'emmet-language-server',
      })
    end,
  },
  -- {
  --   'linux-cultist/venv-selector.nvim',
  --   cmd = 'VenvSelect',
  --   opts = function(_, opts)
  --     local venv = require('venv-selector')
  --     if LazyVim.has('nvim-dap-python') then
  --       opts.dap_enabled = true
  --       opts.search = false
  --       opts.auto_refresh = true
  --       opts.search_workspace = true
  --     end
  --     venv.retrieve_from_cache()
  --     return vim.tbl_deep_extend('force', opts, {
  --       name = {
  --         'venv',
  --         '.venv',
  --         'env',
  --         '.env',
  --       },
  --     })
  --   end,
  --   keys = { { '<leader>cv', '<cmd>:VenvSelect<cr>', desc = 'Select VirtualEnv' } },
  -- },
  -- emmet plugin
  {
    'olrtg/nvim-emmet',
    config = function()
      vim.keymap.set({ 'n', 'v' }, '<leader>cw', function()
        require('nvim-emmet').wrap_with_abbreviation()
      end)
    end,
  },
  -- lsp servers
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'jose-elias-alvarez/typescript.nvim',
      init = function()
        require('lazyvim.util').lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set('n', '<leader>cR', 'TypescriptRenameFile', { desc = 'Rename File', buffer = buffer })
        end)
      end,
    },
    opts = {
      inlay_hints = {
        enabled = false,
      },
      servers = {
        emmet_language_server = {
          filetypes = {
            'css',
            'eruby',
            'html',
            'javascript',
            'javascriptreact',
            'less',
            'sass',
            'scss',
            'svelte',
            'pug',
            'typescriptreact',
            'vue',
          },
        },
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = 'ignore',
              },
            },
            scss = {
              validate = true,
              lint = {
                unknownAtRules = 'ignore',
              },
            },
            less = {
              validate = true,
              lint = {
                unknownAtRules = 'ignore',
              },
            },
          },
          filetypes = {
            'css',
            'eruby',
            'html',
            'javascript',
            'javascriptreact',
            'less',
            'sass',
            'scss',
            'svelte',
            'pug',
            'typescriptreact',
            'vue',
          },
        },
        -- tailwindcss = {
        --   root_dir = function(...)
        --     return require('lspconfig.util').root_pattern('tailwind.config.*')(...)
        --   end,
        -- },
        -- tsserver = {
        --   commands = {
        --     OrganizeImports = {
        --       organize_imports,
        --       description = 'Organize Imports',
        --     },
        --   },
        --   keys = {
        --     { '<leader>co', '<cmd>OrganizeImports<CR>', desc = 'Organize Imports' },
        --     { '<leader>cR', '<cmd>TypescriptRenameFile<CR>', desc = 'Rename File' },
        --     { '<Leader>ce', '<Cmd>EslintFixAll<Return>', desc = 'Eslint FixAll' },
        --   },
        --   -- init_options = {
        --   --   plugins = {
        --   --     {
        --   --       name = '@vue/typescript-plugin',
        --   --       location = vue_language_server_path,
        --   --       languages = { 'vue' },
        --   --     },
        --   --   },
        --   -- },
        --   -- filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
        -- },
      },
    },
  },
}
