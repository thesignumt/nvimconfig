return {
  'jiaoshijie/undotree',
  dependencies = { 'nvim-lua/plenary.nvim' },
  ---@module 'undotree.collector'
  ---@type UndoTreeCollector.Opts
  opts = {
    -- your options
  },
  config = function(_, opts)
    require('undotree').setup(opts)

    require('utils.map').nmap('<leader>u', require('undotree').toggle)
  end,
}
