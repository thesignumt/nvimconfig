local fns = require('utils').fn -- functions
return {
  fns.miplugin('mkcmt', {
    opts = {},
    config = function(_, opts)
      require('mkcmt').setup(opts)

      local nmap = require('utils.map').nmap
      nmap('<leader><leader>c', require('mkcmt').comment)
    end,
  }),
}
