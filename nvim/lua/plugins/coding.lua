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
}
