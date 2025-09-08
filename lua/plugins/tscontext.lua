return {
  'nvim-treesitter/nvim-treesitter-context',
  config = function()
    require('treesitter-context').setup {
      enable = true,
      max_lines = 3,
      trim_scope = 'outer', -- Trim outer scope if too long
      min_window_height = 0, -- Always show
    }
  end,
}
