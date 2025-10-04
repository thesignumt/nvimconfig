-- Better increase/decrease
return {
  'monaqa/dial.nvim',
  keys = {},
  config = function()
    local augend = require 'dial.augend'
    require('dial.config').augends:register_group {
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias['%Y/%m/%d'],
        augend.constant.alias.bool,
        augend.semver.alias.semver,
        augend.constant.new { elements = { 'let', 'const' } },
      },
    }

    local dialmap = require 'dial.map'
    local nmap = require('utils.map').nmap

    nmap('<C-a>', function()
      return dialmap.inc_normal()
    end, 'increment')
    nmap('<C-x>', function()
      return dialmap.dec_normal()
    end, 'decrement')
  end,
}
