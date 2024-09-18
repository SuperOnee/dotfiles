return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = false,
    opts = {
      flavour = 'mocha',
      custom_highlights = function(colors)
        return {
          Visual = { bg = colors.rosewater, fg = colors.surface0 },
        }
      end,
      transparent_background = true,
      integrations = {
        dashboard = true,
        headlines = true,
        flash = true,
        leap = true,
        neotree = true,
        mason = true,
        markdown = true,
        noice = true,
        notifier = true,
        harpoon = true,
        cmp = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },
        gitsigns = true,
        treesitter = true,
        lsp_trouble = true,
        telescope = true,
        navic = { enabled = true, custom_bg = 'lualine' },
        treesitter_context = true,
        notify = true,
        mini = {
          enabled = true,
          indentscope_color = 'rosewater',
        },
        which_key = true,
        semantic_tokens = true,
      },
    },
  },
}
