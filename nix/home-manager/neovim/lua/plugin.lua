local enabled_plugins = {
  require('plugins/catppuccin'),
  {
    'neovim/nvim-lspconfig',
    config = function()
      vim.lsp.enable({
        'nil_ls',
        'lua_ls',
      })
      vim.lsp.config('*', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })
    end,
  },
  require('plugins/lualine'),
  require('plugins/fern'),
  require('plugins/nvim-cmp'),
}

require('lazy').setup(enabled_plugins, {
  dev = {
    fallback = true,
  },
})
