return {
  {
    'ziontee113/icon-picker.nvim',
    config = function()
      require('icon-picker').setup { disable_legacy_commands = true }

      local opts = { noremap = true, silent = true }
      local dblL = '<leader><leader>'

      local m = require 'utils.map'
      local nmap = m.nmap
      local imap = m.imap

      nmap(dblL .. 'i', '<cmd>IconPickerNormal<cr>')
      nmap(dblL .. 'y', '<cmd>IconPickerYank<cr>') --> Yank the selected
      imap('<C-i>', '<cmd>IconPickerInsert<cr>')
    end,
  },
}
