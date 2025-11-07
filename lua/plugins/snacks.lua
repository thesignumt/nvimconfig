return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = vim.tbl_map(function()
    return { enabled = true }
  end, {
    'bigfile',
    'bufdelete',
    'gh',
    'input',
    'notifier',
    'quickfile',
    'scope',
    'statuscolumn',
    'words',
  }),
  config = function(_, opts)
    opts.picker = { sources = { gh_issue = {}, gh_pr = {} } }
    require('snacks').setup(opts)
  end,
  keys = {
    {
      '<leader>gi',
      function()
        require('snacks').picker.gh_issue()
      end,
      desc = 'GitHub Issues (open)',
    },
    {
      '<leader>gI',
      function()
        require('snacks').picker.gh_issue { state = 'all' }
      end,
      desc = 'GitHub Issues (all)',
    },
    {
      '<leader>gp',
      function()
        require('snacks').picker.gh_pr()
      end,
      desc = 'GitHub Pull Requests (open)',
    },
    {
      '<leader>gP',
      function()
        require('snacks').picker.gh_pr { state = 'all' }
      end,
      desc = 'GitHub Pull Requests (all)',
    },
  },
}
