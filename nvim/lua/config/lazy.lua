local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require('lazy').setup({
  spec = {
    -- add LazyVim and import its plugins
    {
      'LazyVim/LazyVim',
      import = 'lazyvim.plugins',
      opts = {
        colorscheme = 'catppuccin-mocha',
        icons = {
          misc = {
            dots = '󰇘',
          },
          ft = {
            octo = '',
          },
          dap = {
            Stopped = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
            Breakpoint = ' ',
            BreakpointCondition = ' ',
            BreakpointRejected = { ' ', 'DiagnosticError' },
            LogPoint = '.>',
          },
          diagnostics = {
            Error = ' ',
            Warn = ' ',
            Hint = ' ',
            Info = ' ',
          },
          git = {
            added = ' ',
            modified = ' ',
            removed = ' ',
          },
          kinds = {
            Array = ' ',
            Boolean = '󱍊 ',
            Class = ' ',
            Codeium = '󰏚 ',
            Color = ' ',
            Control = ' ',
            Collapsed = ' ',
            Constant = ' ',
            Constructor = ' ',
            Copilot = ' ',
            Enum = ' ',
            EnumMember = ' ',
            Event = ' ',
            Field = ' ',
            File = ' ',
            Folder = ' ',
            Function = ' ',
            Interface = ' ',
            Key = ' ',
            Keyword = ' ',
            Method = ' ',
            Module = ' ',
            Namespace = '󰦮 ',
            Null = ' ',
            Number = '󰎠 ',
            Object = ' ',
            Operator = ' ',
            Package = ' v ',
            Property = ' ',
            Reference = ' ',
            Snippet = ' ',
            String = ' ',
            Struct = '󰆼 ',
            Supermaven = '󰚌 ',
            TabNine = '󰏚 ',
            Text = ' ',
            TypeParameter = ' ',
            Unit = ' ',
            Value = ' ',
            Variable = ' ',
          },
        },
      },
    },
    -- import any extras modules here
    -- Languages
    { import = 'lazyvim.plugins.extras.lang.typescript' },
    { import = 'lazyvim.plugins.extras.lang.vue' },
    { import = 'lazyvim.plugins.extras.lang.tailwind' },
    { import = 'lazyvim.plugins.extras.lang.json' },
    { import = 'lazyvim.plugins.extras.lang.markdown' },
    { import = 'lazyvim.plugins.extras.lang.yaml' },
    { import = 'lazyvim.plugins.extras.lang.toml' },
    { import = 'lazyvim.plugins.extras.lang.go' },
    { import = 'lazyvim.plugins.extras.lang.python' },
    { import = 'lazyvim.plugins.extras.lang.docker' },
    { import = 'lazyvim.plugins.extras.lang.sql' },
    -- Coding
    { import = 'lazyvim.plugins.extras.util.mini-hipatterns' },
    { import = 'lazyvim.plugins.extras.coding.mini-surround' },
    { import = 'lazyvim.plugins.extras.linting.eslint' },
    { import = 'lazyvim.plugins.extras.formatting.prettier' },
    { import = 'lazyvim.plugins.extras.coding.luasnip' },
    { import = 'lazyvim.plugins.extras.coding.yanky' },
    { import = 'lazyvim.plugins.extras.coding.neogen' },
    -- Editor
    { import = 'lazyvim.plugins.extras.editor.harpoon2' },
    { import = 'lazyvim.plugins.extras.editor.overseer' },
    { import = 'lazyvim.plugins.extras.editor.snacks_picker' },
    { import = 'lazyvim.plugins.extras.editor.refactoring' },
    { import = 'lazyvim.plugins.extras.editor.mini-diff' },
    -- Dap
    { import = 'lazyvim.plugins.extras.dap.core' },
    -- { import = 'lazyvim.plugins.extras.editor.fzf' },
    -- import/override with your plugins
    { import = 'plugins' },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install. version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  -- install = { colorscheme = { 'tokyonight', 'habamax' } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        'gzip',
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
