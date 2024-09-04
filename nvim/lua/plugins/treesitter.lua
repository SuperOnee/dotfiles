return {
  'nvim-treesitter/nvim-treesitter',
  opts = {
    ensure_installed = {
      'html',
      'css',
      'scss',
      'tsx',
      'sql',
      'gitignore',
      'vimdoc',
      'markdown',
      'lua',
    },
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
