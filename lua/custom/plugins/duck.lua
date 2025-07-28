return {
  'tamton-aquib/duck.nvim',
  config = function()
    vim.keymap.set('n', '<leader>dd', function()
      require('duck').hatch()
    end, { desc = 'duck' })
    vim.keymap.set('n', '<leader>dk', function()
      require('duck').cook()
    end, { desc = 'cook duck' })
    vim.keymap.set('n', '<leader>da', function()
      require('duck').cook_all()
    end, { desc = 'cook all duck' })
  end,
}
