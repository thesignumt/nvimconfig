local miplugin = require('utils').miplugin
return {
  miplugin('mkcmt', {
    opts = {},
    config = function(_, opts)
      local mkcmt = require 'mkcmt'
      mkcmt.setup(opts)

      local nmap = require('utils.map').nmap
      local fn = require('utils.f').fn

      local dblL = '<leader><leader>'
      nmap(dblL .. 'c', fn(mkcmt.comment, { after = true }))
      nmap(dblL .. 'C', fn(mkcmt.comment, { after = false }))
    end,
  }),
}
