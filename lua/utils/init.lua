local Utils = {}

--- get the operating system name
--- @return '"windows"'|'"mac"'|'"linux"'
function Utils.get_os()
  local uname = vim.uv.os_uname()
  local os_name = uname.sysname
  if os_name == 'Windows_NT' then
    return 'windows'
  elseif os_name == 'Darwin' then
    return 'mac'
  else
    return 'linux'
  end
end

---make a lazy plugin spec for my plugins
---@param name string name of plugin (without .nvim) e.g. mkcmt.nvim -> mkcmt
---@param opts table
---@return table
function Utils.miplugin(name, opts)
  return vim.tbl_extend(
    'force',
    vim.deepcopy {
      dir = table.concat {
        'C:\\justcode\\alpha\\plugins\\',
        name,
        '.nvim\\',
      },
      name = name,
    },
    opts
  )
end

-- TODO: ask claude or chatgpt to rewrite this so it is very optimized
function Utils.toggle_comment()
  local line = vim.api.nvim_get_current_line()
  local comment_string = vim.bo.commentstring:match '^(.*)%%s' or '//'

  if line:match('^%s*' .. vim.pesc(comment_string)) then
    line = line:gsub('^%s*' .. vim.pesc(comment_string) .. '%s?', '')
  else
    line = comment_string .. ' ' .. line
  end

  vim.api.nvim_set_current_line(line)
end

return Utils
