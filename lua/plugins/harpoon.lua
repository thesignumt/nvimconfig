return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local nmap = require('utils.map').nmap
    local harpoon = require 'harpoon'
    harpoon:setup()

    nmap('<leader>a', function()
      harpoon:list():add()
    end, 'Harpoon: Mark File')
    nmap('<leader>A', function()
      harpoon:list():remove()
    end, 'Harpoon: RM File')

    nmap('<leader>h', function()
      harpoon.ui:toggle_quick_menu(harpoon:list(), {
        border = 'rounded',
        title_pos = 'center',
        ui_max_width = 60,
        height_in_lines = 8,
      })
    end, 'Toggle Harpoon Menu')

    for key, idx in pairs { h = 1, j = 2, k = 3, l = 4 } do
      nmap('g' .. key, function()
        harpoon:list():select(idx)
      end, 'Harpoon File ' .. idx)
    end

    --[[-------LEGACY-----------------------------------------------------]]
    -- local mark = require 'harpoon.mark'
    -- local ui = require 'harpoon.ui'
    --
    -- nmap('<leader>a', mark.add_file, 'Harpoon: Mark File')
    -- nmap('<leader>A', mark.rm_file, 'Harpoon: RM File')
    -- nmap('<leader>h', ui.toggle_quick_menu, 'Toggle Harpoon Menu')
    -- nmap('<leader>H', mark.clear_all, 'Harpoon: Clear All Files')
    --
    -- local nav_keys = { h = 1, j = 2, k = 3, l = 4 }
    -- for key, idx in pairs(nav_keys) do
    --   nmap('g' .. key, function()
    --     ui.nav_file(idx)
    --   end, 'Harpoon File ' .. idx)
    -- end
  end,
}
