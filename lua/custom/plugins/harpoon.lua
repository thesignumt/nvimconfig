return {
  'ThePrimeagen/harpoon',
  config = function()
    local nmap = require('utils.map').nmap

    local mark = require 'harpoon.mark'
    local ui = require 'harpoon.ui'

    nmap('<leader>a', mark.add_file, 'Harpoon: Mark File')
    nmap('<leader>h', ui.toggle_quick_menu, 'Toggle Harpoon Menu')

    nmap('<leader>1', function()
      ui.nav_file(1)
    end, 'Harpoon File 1')
    nmap('<leader>2', function()
      ui.nav_file(2)
    end, 'Harpoon File 2')
    nmap('<leader>3', function()
      ui.nav_file(3)
    end, 'Harpoon File 3')
    nmap('<leader>4', function()
      ui.nav_file(4)
    end, 'Harpoon File 4')
    nmap('<leader>5', function()
      ui.nav_file(5)
    end, 'Harpoon File 5')
  end,
}
