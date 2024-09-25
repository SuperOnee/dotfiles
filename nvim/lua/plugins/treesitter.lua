return {
  'nvim-treesitter/nvim-treesitter',
  opts = {
    ensure_installed = {
      'html',
      'typescript',
      'javascript',
      'css',
      'scss',
      'vue',
      'go',
      'python',
      'tsx',
      'sql',
      'gitignore',
      'vimdoc',
      'markdown',
      'lua',
      'regex',
      'bash',
      'latex',
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
