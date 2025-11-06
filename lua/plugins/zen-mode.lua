return {
  'folke/zen-mode.nvim',
  config = function()
    local zen = require('utils.zen').new()
    local nmap = require('utils.map').nmap

    nmap('<leader>zz', function()
      zen:zen()
    end, 'zen')
    nmap('<leader>zZ', function()
      zen:ZEN()
    end, 'ZEN')
  end,
}
