local M = {}

--- get the operating system name
--- @return '"windows"'|'"mac"'|'"linux"'
function M.get_os()
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

function M.center_in(outer, inner)
  return (outer - inner) / 2
end

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

--- Pretty-print a Lua table or value in a human-readable format.
---
--- This function recursively prints tables, including nested tables,
--- and handles circular references to avoid infinite loops.
---
---@param tbl table|any The table (or value) to pretty-print.
---@param indent number? Optional. The current indentation level (used internally). Default is 0.
---@param visited table? Optional. Internal table to track visited tables for circular reference detection.
---@return nil
function Pprint(tbl, indent, visited)
  indent = indent or 0
  visited = visited or {}

  if type(tbl) ~= 'table' then
    print(tbl)
    return
  end

  if visited[tbl] then
    print(string.rep('  ', indent) .. '*recursive reference*')
    return
  end
  visited[tbl] = true

  print(string.rep('  ', indent) .. '{')
  for k, v in pairs(tbl) do
    local key
    if type(k) == 'string' then
      key = string.format('%q', k)
    else
      key = tostring(k)
    end

    if type(v) == 'table' then
      io.write(string.rep('  ', indent + 1) .. '[' .. key .. '] = ')
      M.pprint(v, indent + 1, visited)
    else
      local value
      if type(v) == 'string' then
        value = string.format('%q', v)
      else
        value = tostring(v)
      end
      print(string.rep('  ', indent + 1) .. '[' .. key .. '] = ' .. value)
    end
  end
  print(string.rep('  ', indent) .. '}')
end

--- Pretty-print a Lua table or value in a human-readable format.
---
--- This function recursively prints tables, including nested tables,
--- and handles circular references to avoid infinite loops.
---
---@param tbl table|any The table (or value) to pretty-print.
---@param indent number? Optional. The current indentation level (used internally). Default is 0.
---@param visited table? Optional. Internal table to track visited tables for circular reference detection.
---@return nil
function M.pprint(tbl, indent, visited)
  Pprint(tbl, indent, visited)
end

return M
