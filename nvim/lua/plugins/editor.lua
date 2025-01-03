return {
  -- Neotree
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      '3rd/image.nvim', -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    opts = {
      filesystem = {
        filtered_items = {
          visible = false,
          show_hidden_count = true,
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_by_name = {
            '.git',
            'node_modules',
            'bun.lockb',
          },
        },
      },
      window = {
        mappings = {
          ['l'] = 'open',
          ['h'] = 'close_node',
          ['<space>'] = 'none',
          ['Y'] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg('+', path, 'c')
            end,
            desc = 'Copy Path to Clipboard',
          },
          ['O'] = {
            function(state)
              require('lazy.util').open(state.tree:get_node().path, { system = true })
            end,
            desc = 'Open with System Application',
          },
          ['P'] = { 'toggle_preview', config = { use_float = false, use_image_nvim = true } },
        },
      },
    },
  },
  -- Tmux Navigator
  {
    'christoomey/vim-tmux-navigator',
  },
  -- Mini indentscope config overwrite
  {
    'echasnovski/mini.indentscope',
    opts = {
      symbol = '┊',
      options = { try_as_border = true, border = 'both', indent_at_cursor = true },
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
          accept = '<C-y>',
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
    end,
  },
  {
    '3rd/image.nvim',
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
      integrations = {
        -- Notice these are the settings for markdown files
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          -- Set this to false if you don't want to render images coming from
          -- a URL
          download_remote_images = true,
          -- Change this if you would only like to render the image where the
          -- cursor is at
          -- I set this to true, because if the file has way too many images
          -- it will be laggy and will take time for the initial load
          only_render_image_at_cursor = true,
          -- markdown extensions (ie. quarto) can go here
          filetypes = { 'markdown', 'vimwiki' },
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { 'norg' },
        },
        -- This is disabled by default
        -- Detect and render images referenced in HTML files
        -- Make sure you have an html treesitter parser installed
        -- ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/treesitter.lua
        html = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = false,
          only_render_image_at_cursor = true,
        },
        -- This is disabled by default
        -- Detect and render images referenced in CSS files
        -- Make sure you have a css treesitter parser installed
        -- ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/treesitter.lua
        css = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = false,
          only_render_image_at_cursor = true,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,

      -- This is what I changed to make my images look smaller, like a
      -- thumbnail, the default value is 50
      -- max_height_window_percentage = 20,
      max_height_window_percentage = 40,

      -- toggles images when windows are overlapped
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },

      -- auto show/hide images when the editor gains/looses focus
      editor_only_render_when_focused = true,

      -- auto show/hide images in the correct tmux window
      -- In the tmux.conf add `set -g visual-activity off`
      tmux_show_only_in_active_window = true,

      -- render image files as images when opened
      hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },
    },
  },
  -- Blink
  -- TODO: uncomment this code block when the issue is fixed, stick with nvim.cmp for now
  -- https://github.com/Saghen/blink.cmp/issues/657
  -- {
  --   'saghen/blink.cmp',
  --   opts = {
  --     sources = {
  --       default = { 'copilot', 'lsp', 'path', 'snippets', 'luasnip', 'buffer', 'lazydev' },
  --       compat = {},
  --       cmdline = {},
  --       providers = {
  --         lsp = {
  --           name = 'lsp',
  --           enabled = true,
  --           module = 'blink.cmp.sources.lsp',
  --           kind = 'LSP',
  --           should_show_items = true,
  --           score_offset = 90,
  --         },
  --         luasnip = {
  --           name = 'luasnip',
  --           enabled = true,
  --           module = 'blink.cmp.sources.luasnip',
  --           should_show_items = true,
  --           min_keyword_length = 1,
  --           score_offset = 80,
  --           fallbacks = { 'snippets' },
  --         },
  --         snippets = {
  --           name = 'snippets',
  --           enabled = true,
  --           module = 'blink.cmp.sources.snippets',
  --           min_keyword_length = 1,
  --           score_offset = 70,
  --         },
  --         copilot = {
  --           name = 'copilot',
  --           enabled = true,
  --           module = 'blink-cmp-copilot',
  --           kind = 'Copilot',
  --           score_offset = 10,
  --           async = true,
  --         },
  --       },
  --     },
  --     snippets = {
  --       expand = function(snippet, _)
  --         require('luasnip').lsp_expand(snippet)
  --       end,
  --       active = function(filter)
  --         if filter and filter.direction then
  --           return require('luasnip').jumpable(filter.direction)
  --         end
  --         return require('luasnip').in_snippet()
  --       end,
  --       jump = function(direction)
  --         require('luasnip').jump(direction)
  --       end,
  --     },
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
