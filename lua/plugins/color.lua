return {
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        styles = {
          comments = { italic = false },
        },
        on_colors = function(colors) end,
        on_highlights = function(highlights, colors) end,
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      require('rose-pine').setup {
        disable_background = true,
        styles = {
          italic = false,
        },
      }
    end,
  },
  {
    'vague2k/vague.nvim',
    lazy = false,
    config = function()
      require('vague').setup {
        transparent = true,
      }
    end,
  },
}
