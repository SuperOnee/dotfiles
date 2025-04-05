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
  -- Copilot
  {
    'zbirenbaum/copilot.lua',
    event = 'VeryLazy',
    cmd = 'Copilot',
    build = ':Copilot auth',
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = '<C-i>',
          -- accept_word = '<C-h>',
          accept_line = '<C-j>',
          next = '<M-l>',
          prev = '<M-h>',
          dismiss = '<C-]>',
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = false,
      },
    },
  },
  -- Codeium
  -- {
  --   'Exafunction/codeium.nvim',
  --   cmd = 'Codeium',
  --   build = ':Codeium Auth',
  --   opts = {
  --     enable_cmp_source = false,
  --     virtual_text = {
  --       enabled = true,
  --       key_bindings = {
  --         accept = false, -- handled by nvim-cmp / blink.cmp
  --         next = '<M-]>',
  --         prev = '<M-[>',
  --       },
  --     },
  --   },
  -- },
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
  -- Cmp colorful menu
  {
    'xzbdmw/colorful-menu.nvim',
    event = 'VeryLazy',
    config = function()
      -- You don't need to set these options.
      require('colorful-menu').setup({
        ls = {
          lua_ls = {
            -- Maybe you want to dim arguments a bit.
            arguments_hl = '@comment',
          },
          gopls = {
            -- By default, we render variable/function's type in the right most side,
            -- to make them not to crowd together with the original label.

            -- when true:
            -- foo             *Foo
            -- ast         "go/ast"

            -- when false:
            -- foo *Foo
            -- ast "go/ast"
            align_type_to_right = true,
            -- When true, label for field and variable will format like "foo: Foo"
            -- instead of go's original syntax "foo Foo".
            add_colon_before_type = false,
          },
          -- for lsp_config or typescript-tools
          ts_ls = {
            extra_info_hl = '@comment',
          },
          vtsls = {
            extra_info_hl = '@comment',
          },
          ['rust-analyzer'] = {
            -- Such as (as Iterator), (use std::io).
            extra_info_hl = '@comment',
          },
          clangd = {
            -- Such as "From <stdio.h>".
            extra_info_hl = '@comment',
          },
          roslyn = {
            extra_info_hl = '@comment',
          },
          -- The same applies to pyright/pylance
          basedpyright = {
            -- It is usually import path such as "os"
            extra_info_hl = '@comment',
          },

          -- If true, try to highlight "not supported" languages.
          fallback = true,
        },
        -- If the built-in logic fails to find a suitable highlight group,
        -- this highlight is applied to the label.
        fallback_highlight = '@variable',
        -- If provided, the plugin truncates the final displayed text to
        -- this width (measured in display cells). Any highlights that extend
        -- beyond the truncation point are ignored. When set to a float
        -- between 0 and 1, it'll be treated as percentage of the width of
        -- the window: math.floor(max_width * vim.api.nvim_win_get_width(0))
        -- Default 60.
        max_width = 60,
      })
    end,
  },
  -- Blink Cmp
  {
    'saghen/blink.cmp',
    opts = function(_, opts)
      opts.completion = {
        menu = {
          draw = {
            columns = { { 'kind_icon' }, { 'label', gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require('colorful-menu').blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require('colorful-menu').blink_components_highlight(ctx)
                end,
              },
            },
          },
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
      opts.keymap = {
        preset = 'enter',
        ['<C-y>'] = { 'select_and_accept' },
        ['<C-l>'] = { 'snippet_forward', 'fallback' },
        ['<C-h>'] = { 'snippet_backward', 'fallback' },
      }
    end,
  },
}
