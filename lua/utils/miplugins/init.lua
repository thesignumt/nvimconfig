local miplugin = require('utils').miplugin
local m = require 'utils.map'
local nmap = m.nmap
local fn = require('utils.f').fn

return {
  miplugin('mkcmt', {
    opts = {},
    config = function(_, opts)
      local mkcmt = require 'mkcmt'
      mkcmt.setup(opts)

      nmap(m.dblL 'c', fn(mkcmt.comment, { after = true }))
      nmap(m.dblL 'C', fn(mkcmt.comment, { after = false }))
    end,
  }),
}
