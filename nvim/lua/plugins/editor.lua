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
          accept = '<C-l>',
          accept_word = '<C-h>',
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
  {
    'saghen/blink.cmp',
    opts = {
      completion = {
        list = {
          max_items = 15,
          selection = 'preselect',
        },
      },
    },
  },
}
