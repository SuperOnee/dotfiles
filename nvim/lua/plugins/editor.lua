return {
  -- Neotree
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      '3rd/image.nvim', -- Optional image support in preview window: See `# Preview Mode` for more information
    },
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
      window = {
        mappings = {
          ['l'] = 'open',
          ['h'] = 'close_node',
          ['<space>'] = 'none',
          ['Y'] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg('+', path, 'c')
            end,
            desc = 'Copy Path to Clipboard',
          },
          ['O'] = {
            function(state)
              require('lazy.util').open(state.tree:get_node().path, { system = true })
            end,
            desc = 'Open with System Application',
          },
          ['P'] = { 'toggle_preview', config = { use_float = false, use_image_nvim = true } },
        },
      },
    },
  },
  -- Yazi
  {
    'mikavilpas/yazi.nvim',
    event = 'VeryLazy',
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        '<leader>e',
        '<cmd>Yazi<cr>',
        desc = 'Open yazi at the current file',
      },
      {
        -- Open in the current working directory
        '<leader>cw',
        '<cmd>Yazi cwd<cr>',
        desc = "Open the file manager in nvim's working directory",
      },
      {
        -- NOTE: this requires a version of yazi that includes
        -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
        '<c-up>',
        '<cmd>Yazi toggle<cr>',
        desc = 'Resume the last yazi session',
      },
    },
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = true,
      keymaps = {
        show_help = '<f1>',
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
    '3rd/image.nvim',
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
      integrations = {
        -- Notice these are the settings for markdown files
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          -- Set this to false if you don't want to render images coming from
          -- a URL
          download_remote_images = true,
          -- Change this if you would only like to render the image where the
          -- cursor is at
          -- I set this to true, because if the file has way too many images
          -- it will be laggy and will take time for the initial load
          only_render_image_at_cursor = true,
          -- markdown extensions (ie. quarto) can go here
          filetypes = { 'markdown', 'vimwiki' },
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { 'norg' },
        },
        -- This is disabled by default
        -- Detect and render images referenced in HTML files
        -- Make sure you have an html treesitter parser installed
        -- ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/treesitter.lua
        html = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = false,
          only_render_image_at_cursor = true,
        },
        -- This is disabled by default
        -- Detect and render images referenced in CSS files
        -- Make sure you have a css treesitter parser installed
        -- ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/treesitter.lua
        css = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = false,
          only_render_image_at_cursor = true,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,

      -- This is what I changed to make my images look smaller, like a
      -- thumbnail, the default value is 50
      -- max_height_window_percentage = 20,
      max_height_window_percentage = 40,

      -- toggles images when windows are overlapped
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },

      -- auto show/hide images when the editor gains/looses focus
      editor_only_render_when_focused = true,

      -- auto show/hide images in the correct tmux window
      -- In the tmux.conf add `set -g visual-activity off`
      tmux_show_only_in_active_window = true,

      -- render image files as images when opened
      hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },
    },
  },
  -- overseer
  {
    'stevearc/overseer.nvim',
    opts = {
      templates = { 'builtin', 'user.run_script' },
    },
  },
}
