return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = false,
    opts = {
      transparent_background = true,
      integrations = {
        dashboard = true,
        flash = true,
        leap = false,
        neotree = true,
        mason = true,
        noice = true,
        notifier = true,
        harpoon = true,
        cmp = true,
        gitsigns = true,
        treesitter = true,
        treesitter_context = true,
        notify = true,
        mini = {
          enabled = false,
          indentscope_color = '',
        },
      },
    },
  },
}
