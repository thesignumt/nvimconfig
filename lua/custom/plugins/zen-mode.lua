return {
  'folke/zen-mode.nvim',
  opts = {
    window = {
      options = {
        winborder = 'none', -- or whatever you prefer instead of "rounded"
      },
    },
  },
  config = function(_, opts)
    require('zen-mode').setup(opts)
  end,
}
