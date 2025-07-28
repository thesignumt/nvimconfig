local plugins = 'C:/justcode/alpha/plugins/'
return {
  {
    dir = plugins .. 'ttls.nvim',
    config = function()
      -- require("ttls")
    end,
  },
  {
    dir = plugins .. 'shurl.nvim',
    config = function()
      require 'shurl'
    end,
  },
}
