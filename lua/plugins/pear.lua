return {
  'sylvanfranklin/pear',
  config = function()
    local pear = require 'pear'
    local nmap = require('utils.map').nmap
    nmap('<leader>b', pear.jump_pair, 'pear')
  end,
}
