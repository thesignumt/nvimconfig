return {
  { 'github/copilot.vim' },
  {
    'olimorris/codecompanion.nvim',
    tag = 'v17.33.0',
    opts = {
      log_level = 'DEBUG',
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
  },
}
