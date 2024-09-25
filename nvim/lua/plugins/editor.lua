return {
  -- Neotree
  {
    'nvim-neo-tree/neo-tree.nvim',
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
  -- Telescope
  {
    {
      'telescope.nvim',
      dependencies = {
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          build = 'make',
        },
        'nvim-telescope/telescope-file-browser.nvim',
      },
      keys = {
        {
          '<Leader>fP',
          function()
            require('telescope.builtin').find_files({
              cwd = require('lazy.core.config').options.root,
            })
          end,
          desc = 'Find Plugin File',
        },
        {
          '<Leader><Leader>',
          function()
            local builtin = require('telescope.builtin')
            builtin.find_files({
              no_ignore = false,
              hidden = true,
            })
          end,
          desc = 'Lists files in your current working directory, respects .gitignore',
        },
        -- {
        --   '<leader><leader>',
        --   function()
        --     local builtin = require('telescope.builtin')
        --     builtin.buffers()
        --   end,
        --   desc = 'Lists open buffers',
        -- },
        {
          '<Leader>;',
          function()
            local builtin = require('telescope.builtin')
            builtin.resume()
          end,
          desc = 'Resume the previous telescope picker',
        },
        -- {
        --   ';e',
        --   function()
        --     local builtin = require('telescope.builtin')
        --     builtin.diagnostics()
        --   end,
        --   desc = 'Lists Diagnostics for all open buffers or a specific buffer',
        -- },
        -- {
        --   ';s',
        --   function()
        --     local builtin = require('telescope.builtin')
        --     builtin.treesitter()
        --   end,
        --   desc = 'Lists Function names, variables, from Treesitter',
        -- },
        {
          '<Leader>fs',
          function()
            local telescope = require('telescope')

            local function telescope_buffer_dir()
              return vim.fn.expand('%:p:h')
            end

            telescope.extensions.file_browser.file_browser({
              path = '%:p:h',
              cwd = telescope_buffer_dir(),
              respect_gitignore = false,
              hidden = true,
              grouped = true,
              previewer = false,
              initial_mode = 'insert',
              layout_config = { height = 40 },
            })
          end,
          desc = 'Open File Browser with the path of the current buffer',
        },
      },
      config = function(_, opts)
        local telescope = require('telescope')
        local actions = require('telescope.actions')
        local fb_actions = require('telescope').extensions.file_browser.actions
        opts.defaults = vim.tbl_deep_extend('force', opts.defaults, {
          wrap_results = true,
          layout_strategy = 'horizontal',
          layout_config = { prompt_position = 'top' },
          sorting_strategy = 'ascending',
          winblend = 0,
          mappings = {
            n = {},
          },
        })
        opts.pickers = {
          diagnostics = {
            theme = 'ivy',
            initial_mode = 'normal',
            layout_config = {
              preview_cutoff = 9999,
            },
          },
        }
        opts.extensions = {
          file_browser = {
            theme = 'dropdown',
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            mappings = {
              -- your custom insert mode mappings
              ['n'] = {
                -- your custom normal mode mappings
                ['N'] = fb_actions.create,
                ['h'] = fb_actions.goto_parent_dir,
                ['/'] = function()
                  vim.cmd('startinsert')
                end,
                ['<C-u>'] = function(prompt_bufnr)
                  for _ = 1, 10 do
                    actions.move_selection_previous(prompt_bufnr)
                  end
                end,
                ['<C-d>'] = function(prompt_bufnr)
                  for _ = 1, 10 do
                    actions.move_selection_next(prompt_bufnr)
                  end
                end,
                ['<PageUp>'] = actions.preview_scrolling_up,
                ['<PageDown>'] = actions.preview_scrolling_down,
              },
            },
          },
        }
        telescope.setup(opts)
        require('telescope').load_extension('fzf')
        require('telescope').load_extension('file_browser')
      end,
    },
  },
  -- Cmp completion
  {
    'hrsh7th/cmp-cmdline',
    config = function()
      local cmp = require('cmp')
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline({
          ['<Tab>'] = { c = cmp.mapping.confirm({ select = false }) },
        }),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          { name = 'cmdline' },
        }),
      })
    end,
  },
  -- tailwind-colorizer-cmp
  {
    'roobert/tailwindcss-colorizer-cmp.nvim',
    -- optionally, override the default options:
    config = function()
      require('tailwindcss-colorizer-cmp').setup({
        color_square_width = 3,
      })
    end,
  },
  -- nvim cmp
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'onsails/lspkind.nvim',
    },
    opts = function(_, opts)
      opts.window = {
        completion = {
          winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
          col_offset = -3,
          side_padding = 0,
        },
      }
      opts.formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, item)
          if item.kind == 'Color' and entry.completion_item.documentation then
            local kind = require('tailwindcss-colorizer-cmp').formatter(entry, item)
            return kind
          end
          local kind = require('lspkind').cmp_format({ mode = 'symbol_text', maxwidth = 50 })(entry, item)
          local strings = vim.split(kind.kind, '%s', { trimempty = true })
          kind.kind = ' ' .. (strings[1] or '') .. ' '
          kind.menu = '    (' .. (strings[2] or '') .. ')'
          return kind
        end,
      }
    end,
  },
}
