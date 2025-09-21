return {
  'atiladefreitas/dooing',
  config = function()
    require('dooing').setup {
      quick_keys = false,
    }
    local nmap = require('utils.map').nmap

    nmap('<leader>n', ':Dooing<cr>', 'todo')
    nmap('<leader>N', ':DooingLocal<cr>', 'todo local')
  end,
}
