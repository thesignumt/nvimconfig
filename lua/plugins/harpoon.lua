return {
  'ThePrimeagen/harpoon',
  -- branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local nmap = require('utils.map').nmap

    local mark = require 'harpoon.mark'
    local ui = require 'harpoon.ui'

    nmap('<leader>a', mark.add_file, 'Harpoon: Mark File')
    nmap('<leader>A', mark.rm_file, 'Harpoon: RM File')
    nmap('<leader>h', ui.toggle_quick_menu, 'Toggle Harpoon Menu')
    nmap('<leader>H', mark.clear_all, 'Harpoon: Clear All Files')

    local nav_keys = { h = 1, j = 2, k = 3, l = 4 }
    for key, idx in pairs(nav_keys) do
      nmap(table.concat { 'g', key }, function()
        ui.nav_file(idx)
      end, 'Harpoon File ' .. idx)
    end
    -- local harpoon = require 'harpoon'
    -- local nmap = require('utils.map').nmap
    -- nmap('<leader>a', function()
    --   harpoon:list():add()
    -- end)
    -- nmap('<leader>h', function()
    --   harpoon.ui:toggle_quick_menu(harpoon:list())
    -- end)
    --
    -- local maps = { h = 1, j = 2, k = 3, l = 4 }
    -- for key, idx in pairs(maps) do
    --   nmap('g' .. key, function()
    --     return harpoon:list():select(idx)
    --   end)
    -- end
  end,
}
