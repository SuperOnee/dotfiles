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
            'less',
            'sass',
            'scss',
            'pug',
          },
        },
        vtsls = {
          settings = {
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = false,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                  entriesLimit = 30,
                },
              },
            },
          },
        },
      },
    },
  },
}
