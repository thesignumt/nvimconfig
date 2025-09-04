return {
  'ThePrimeagen/harpoon',
  config = function()
    local nmap = require('utils.map').nmap

    local mark = require 'harpoon.mark'
    local ui = require 'harpoon.ui'

    nmap('<leader>a', mark.add_file, 'Harpoon: Mark File')
    nmap('<leader>h', ui.toggle_quick_menu, 'Toggle Harpoon Menu')

    local nav_keys = { h = 1, j = 2, k = 3, l = 4, [';'] = 5 }
    for key, idx in pairs(nav_keys) do
      nmap('g' .. key, function()
        ui.nav_file(idx)
      end, 'Harpoon File ' .. idx)
    end
  end,
}
