return {
  {
    'atiladefreitas/dooing',
    config = function()
      require('dooing').setup {
        quick_keys = false,
      }

      local nmap = require('utils.map').nmap
      nmap('<leader>k', ':Dooing<cr>', 'todo')
      nmap('<leader>K', ':DooingLocal<cr>', 'todo local')
    end,
  },
}
