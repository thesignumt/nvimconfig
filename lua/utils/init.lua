local M = {}

M.fn = {
  ---make a lazy plugin spec for my plugins
  ---@param name string name of plugin (without .nvim) e.g. mkcmt.nvim -> mkcmt
  ---@param opts table
  ---@return table
  miplugin = function(name, opts)
    return vim.tbl_extend(
      'force',
      vim.deepcopy {
        dir = ('%s%s%s'):format(
          'C:\\justcode\\alpha\\plugins\\',
          name,
          '.nvim\\'
        ),
        name = name,
      },
      opts
    )
  end,
}

return M
