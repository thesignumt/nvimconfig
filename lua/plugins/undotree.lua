return {
  'mbbill/undotree',

  config = function()
    require('utils.map').nmap('<leader>u', vim.cmd.UndotreeToggle, 'undotree')
  end,
}
