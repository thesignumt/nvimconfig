return {
  {
    'ziontee113/icon-picker.nvim',
    config = function()
      require('icon-picker').setup { disable_legacy_commands = true }

      local opts = { noremap = true, silent = true }
      local dblL = '<leader><leader>'

      vim.keymap.set('n', dblL .. 'i', '<cmd>IconPickerNormal<cr>', opts)
      vim.keymap.set('n', dblL .. 'y', '<cmd>IconPickerYank<cr>', opts) --> Yank the selected
      vim.keymap.set('i', '<C-i>', '<cmd>IconPickerInsert<cr>', opts)
    end,
  },
}
