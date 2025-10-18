return {
  {
    'ziontee113/icon-picker.nvim',
    config = function()
      require('icon-picker').setup { disable_legacy_commands = true }

      local m = require 'utils.map'
      local nmap = m.nmap

      nmap(m.dblL 'i', ':IconPickerNormal<cr>')
      nmap(m.dblL 'y', ':IconPickerYank<cr>') --> Yank the selected
    end,
  },
}
