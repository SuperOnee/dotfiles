return {
  {
    'simrat39/symbols-outline.nvim',
    keys = { { '<leader>cs', '<cmd>SymbolsOutline<cr>', desc = 'Symbols Outline' } },
    cmd = 'SymbolsOutline',
    opts = {
      position = 'right',
    },
  },
  {
    'NvChad/nvim-colorizer.lua',
    event = 'VeryLazy',
    opts = {
      user_default_options = {
        tailwind = true,
        always_update = true,
      },
    },
  },
  -- Friendly Snippets
  {
    'rafamadriz/friendly-snippets',
    event = 'VeryLazy',
    config = function()
      require('luasnip').filetype_extend('typescriptreact', { 'typescript' })
      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_snipmate').lazy_load()
    end,
  },
  -- Blink Cmp
  {
    'saghen/blink.cmp',
    dependencies = {
      'Kaiser-Yang/blink-cmp-dictionary',
    },
    event = 'InsertEnter',
    opts = function(_, opts)
      opts.fuzzy = {
        sorts = {
          'exact',
          'score',
          'sort_text',
        },
      }

      opts.snippets = {
        preset = 'luasnip',
      }
      opts.completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { 'lsp' },
            columns = { { 'kind_icon' }, { 'label', gap = 1 }, { 'kind' } },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = vim.g.ai_cmp,
        },
      }

      opts.cmdline = {
        enabled = true,
        completion = {
          menu = {
            auto_show = true,
          },
        },
      }
      -- Blink source
      opts.sources = {
        compat = {},
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        per_filetype = {
          sql = { 'dadbod' },
          lua = { inherit_defaults = true, 'lazydev' },
          markdown = { inherit_defaults = true, 'dictionary' },
          codecompanion = { inherit_defaults = true, 'codecompanion' },
        },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
          snippets = {
            name = 'Snippets',
            module = 'blink.cmp.sources.snippets',
            min_keyword_length = 2,
            max_items = 3,
            score_offset = 100,
          },
          path = {
            name = 'Path',
            module = 'blink.cmp.sources.path',
            score_offset = 150,
            opts = {},
          },
          lsp = {
            name = 'LSP',
            module = 'blink.cmp.sources.lsp',
            opts = {},
            enabled = true,
            async = false,
            score_offset = 130,
          },
          dadbod = {
            module = 'vim_dadbod_completion.blink',
            score_offset = 90,
          },
          codecompanion = {
            name = 'CodeCompanion',
            score_offset = 90,
            module = 'codecompanion.providers.completion.blink',
            enabled = true,
          },
          buffer = {
            max_items = 3,
            score_offset = 80,
          },
          dictionary = {
            name = 'Dict',
            module = 'blink-cmp-dictionary',
            min_keyword_length = 3,
            max_items = 6,
            score_offset = 60,
            opts = {
              dictionary_files = { vim.fn.expand('~/.config/nvim/dictionary/words.txt') },
            },
          },
        },
      }

      opts.signature = { enabled = true }

      opts.keymap = {
        preset = 'enter',
        ['<C-y>'] = { 'select_and_accept' },
        ['<C-l>'] = { 'snippet_forward', 'fallback' },
        ['<C-h>'] = { 'snippet_backward', 'fallback' },
      }
    end,
  },
  -- Render markdown
  {
    'MeanderingProgrammer/render-markdown.nvim',
    event = 'VeryLazy',
    opts = function(_, opts)
      opts.checkbox = {
        enabled = true,
      }
    end,
  },
}
