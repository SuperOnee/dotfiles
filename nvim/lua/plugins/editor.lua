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
  -- Indent BlankLine
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'LazyFile',
    main = 'ibl',
    opts = function(_, opts)
      local highlight = {
        'RainbowRed',
        'RainbowYellow',
        'RainbowBlue',
        'RainbowOrange',
        'RainbowGreen',
        'RainbowViolet',
        'RainbowCyan',
      }

      local hooks = require('ibl.hooks')
      -- -- create the highlight groups in the highlight setup hook, so they are reset
      -- -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
        vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
        vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
        vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
        vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
        vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
        vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
      end)
      opts.indent.highlight = highlight
    end,
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
}
