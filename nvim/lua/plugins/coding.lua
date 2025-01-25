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
    opts = {
      user_default_options = {
        tailwind = true,
      },
    },
  },
  -- Copilot
  {
    'zbirenbaum/copilot.lua',
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
  -- cmdline
  {
    'hrsh7th/cmp-cmdline',
    config = function()
      local cmp = require('cmp')
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline({
          ['<C-l>'] = { c = cmp.mapping.confirm({ select = false }) },
        }),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          { name = 'cmdline' },
        }),
      })
    end,
  },
  -- Cmp
  {
    'hrsh7th/nvim-cmp',
    dependencies = { -- this will only be evaluated if nvim-cmp is enabled
      {
        'zbirenbaum/copilot-cmp',
        opts = {},
        keys = {
          {
            '<C-l>',
            function()
              require('luasnip').jump(1)
            end,
            mode = { 'i', 's' },
          },
          {
            '<C-h>',
            function()
              require('luasnip').jump(-1)
            end,
            mode = { 'i', 's' },
          },
        },
        config = function(_, opts)
          local copilot_cmp = require('copilot_cmp')
          copilot_cmp.setup(opts)
          -- attach cmp source whenever copilot attaches
          -- fixes lazy-loading issues with the copilot cmp source
          LazyVim.lsp.on_attach(function()
            copilot_cmp._on_insert_enter({})
          end, 'copilot')
        end,
        specs = {
          {
            'hrsh7th/nvim-cmp',
            optional = true,
            ---@param opts cmp.ConfigSchema
            opts = function(_, opts)
              table.insert(opts.sources, 1, {
                name = 'copilot',
                group_index = 1,
                priority = 100,
              })
            end,
          },
        },
      },
    },
    opts = function(_, opts)
      local cmp = require('cmp')
      cmp.mapping.preset.insert({
        ['<C-l>'] = function(fallback)
          return LazyVim.cmp.map({ 'snippet_forward' }, fallback)()
        end,
        ['<C-h>'] = function(fallback)
          return LazyVim.cmp.map({ 'snippet_backward' }, fallback)()
        end,
      })
      opts.formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          local icon = LazyVim.config.icons.kinds[vim_item.kind]
          if icon then
            vim_item.kind = icon
          end
          local highlights_info = require('colorful-menu').cmp_highlights(entry)
          if highlights_info ~= nil then
            vim_item.abbr_hl_group = highlights_info.highlights
            vim_item.abbr = highlights_info.text
          end
          return vim_item
        end,
      }
    end,
  },
  {
    'xzbdmw/colorful-menu.nvim',
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
  -- Blink
  -- TODO: uncomment this code block when the issue is fixed, stick with nvim.cmp for now
  -- https://github.com/Saghen/blink.cmp/issues/657
  -- {
  --   'saghen/blink.cmp',
  --   opts = {
  --     completion = {
  --       documentation = {
  --         auto_show = true,
  --         auto_show_delay_ms = 0,
  --         window = {
  --           border = 'rounded',
  --         },
  --       },
  --     },
  --     signature = {
  --       window = { border = 'rounded' },
  --     },
  --     keymap = {
  --       preset = 'enter',
  --       ['<Tab>'] = { 'snippet_forward', 'fallback' },
  --       ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
  --       ['<C-l>'] = { 'snippet_forward', 'fallback' },
  --       ['<C-h>'] = { 'snippet_backward', 'fallback' },
  --     },
  --   },
  -- },
}
