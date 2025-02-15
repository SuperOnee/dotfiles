return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter-context',
      opts = {
        enable = true,
        max_lines = 3,
        line_numbers = true,
        mode = 'cursor',
        trim_scope = 'outer',
      },
    },
    -- {
    --   'nvim-treesitter/playground',
    -- },
  },
  opts = {
    ensure_installed = {
      'html',
      'tsx',
      'typescript',
      'javascript',
      'css',
      'scss',
      'vue',
      'go',
      'python',
      'sql',
      'gitignore',
      'vimdoc',
      'markdown',
      'yaml',
      'lua',
      'regex',
      'bash',
      'latex',
    },
    highlight = {
      enable = true,
    },
    -- playground = {
    --   enable = true,
    --   disable = {},
    --   updatetime = 25,
    --   persist_queries = false,
    -- },
    incremental_selection = {
      enable = true,
      -- keymaps = {
      --   init_selection = ',',
      --   node_incremental = ',',
      --   scope_incremental = false,
      --   node_decremental = '.',
      -- },
    },
  },
}
