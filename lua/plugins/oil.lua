return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
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
      },
    }
    local nmap = require('utils.map').nmap
    nmap('<leader>e', ':Oil --float<cr>', { desc = 'oil' })
    nmap('<leader>ee', ':Oil --float<cr>', { desc = 'oil' })
    nmap('<leader>ep', function()
      local file_dir = vim.fn.expand '%:p:h' -- get the current file's directory
      if file_dir == '' then
        vim.notify('No file detected!', vim.log.levels.WARN)
        return
      end

      vim.cmd('cd ' .. file_dir)
      vim.notify('cd into: ' .. file_dir, vim.log.levels.INFO)
    end, { desc = 'cd into current file' })
  end,
}
