local fns = require('utils').fn -- functions
return {
  fns.miplugin('mkcmt', {
    opts = {},
    config = function(_, opts)
      local mkcmt = require 'mkcmt'
      mkcmt.setup(opts)

      local nmap = require('utils.map').nmap
      local after = function()
        mkcmt.comment { after = true }
      end
      local back = function()
        mkcmt.comment { after = false }
      end

      local dblL = '<leader><leader>'
      nmap(dblL .. 'c', after)
      nmap(dblL .. 'C', back)
    end,
  }),
}
