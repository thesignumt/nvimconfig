return {
  'hedyhli/outline.nvim',
  config = function()
    -- Example mapping to toggle outline
    require('utils.map').nmap(
      '<leader><leader>o',
      '<cmd>Outline<CR>',
      'Toggle Outline'
    )

    require('outline').setup {
      -- Your setup opts here (leave empty to use defaults)
    }
  end,
}
