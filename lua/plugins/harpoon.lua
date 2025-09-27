return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local nmap = require('utils.map').nmap
    local obj = require('utils.f').inst_fn
    local harpoon = require 'harpoon'
    harpoon:setup()

    nmap('<leader>a', obj(harpoon:list(), 'add')(), 'Harpoon: Mark File')
    nmap('<leader>A', obj(harpoon:list(), 'remove')(), 'Harpoon: RM File')

    nmap('<leader>h', function()
      harpoon.ui:toggle_quick_menu(harpoon:list(), {
        border = 'rounded',
        title_pos = 'center',
        ui_max_width = 60,
        height_in_lines = 8,
      })
    end, 'Toggle Harpoon Menu')

    local keys = { h = 1, j = 2, k = 3, l = 4 }
    for key, idx in pairs(keys) do
      nmap('g' .. key, function()
        harpoon:list():select(idx)
      end, 'Harpoon File ' .. idx)
    end

    for key, idx in pairs(keys) do
      nmap('g<C-' .. key .. '>', function()
        harpoon:list():replace_at(idx)
      end, 'Harpoon Replace ' .. idx)
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
