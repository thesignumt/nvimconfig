return {
  {
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false,
  },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
}
