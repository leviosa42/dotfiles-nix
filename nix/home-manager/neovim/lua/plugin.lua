local enabled_plugins = {
  require('plugins/catppuccin'),
  {
    'neovim/nvim-lspconfig',
  },
  require('plugins/lualine'),
  require('plugins.fern'),
}

require('lazy').setup(enabled_plugins, {
  dev = {
    fallback = true,
  },
})
