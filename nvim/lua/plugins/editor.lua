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
  {
    'nvim-lualine/lualine.nvim',
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 2, LazyVim.lualine.cmp_source('codeium'))
    end,
  },
  -- Codeium
  {
    'Exafunction/codeium.nvim',
    cmd = 'Codeium',
    build = ':Codeium Auth',
    opts = {
      enable_cmp_source = false,
      virtual_text = {
        enabled = true,
        key_bindings = {
          accept = false, -- handled by nvim-cmp / blink.cmp
          next = '<M-]>',
          prev = '<M-[>',
        },
      },
    },
  },
  {
    'saghen/blink.cmp',
    opts = {
      sources = {
        compact = { 'codeium' },
        providers = { codeium = { kind = 'Codeium' } },
      },
    },
  },
}
