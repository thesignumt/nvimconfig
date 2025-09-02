return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('oil').setup {
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        natural_order = true,
        is_always_hidden = function(name, _)
          return name == '..' or name == '.git'
        end,
      },
      win_options = {
        wrap = true,
      },
      float = {
        padding = 2,
        max_width = 80,
        max_height = 25,
        border = 'rounded',
        win_options = {
          winblend = 0,
        },
      },
    }
    vim.keymap.set('n', '<leader>e', ':Oil --float<cr>', { desc = 'oil' })
  end,
}
