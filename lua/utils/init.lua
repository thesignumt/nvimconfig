local M = {}

---make a lazy plugin spec for my plugins
---@param name string name of plugin (without .nvim) e.g. mkcmt.nvim -> mkcmt
---@param opts table
---@return table
function M.miplugin(name, opts)
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
end

function M.toggle_comment()
  local line = vim.api.nvim_get_current_line()
  local comment_string = vim.bo.commentstring:match '^(.*)%%s' or '//'

  if line:match('^%s*' .. vim.pesc(comment_string)) then
    line = line:gsub('^%s*' .. vim.pesc(comment_string) .. '%s?', '')
  else
    line = comment_string .. ' ' .. line
  end

  vim.api.nvim_set_current_line(line)
end

return M
