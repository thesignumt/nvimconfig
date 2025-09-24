local M = {}

M.fun = function(t)
  local f = t[1]
  local args = { table.unpack(t, 2) }
  return function()
    return f(table.unpack(args))
  end
end

---function creator
---@param f function
---@param ... any
---@return function
M.fn = function(f, ...)
  local args = { ... }
  return function(...)
    return f(unpack(args), ...)
  end
end

---Usage:
---inst_fn(obj)({fn='hello', is_fn=false}, ...)
M.inst_fn = function(inst)
  ---@param data {fn:string, is_fn: boolean?}
  ---@param ... any
  return function(data, ...)
    local args = { ... }
    return function(...)
      local f = inst[data.fn]
      if f == nil then
        error('function not found: ' .. tostring(data.fn))
      end

      if data.is_fn == true then
        return f(unpack(args), ...)
      else
        return f(inst, unpack(args), ...)
      end
    end
  end
end

-- Multiple function creators
---@param ... table
---@return function
M.fns = function(...)
  local tables = { ... }

  -- Prepare all functions
  local funcs = {}
  for _, tbl in ipairs(tables) do
    local creator = tbl[1] -- first element is the function creator
    local args = { unpack(tbl, 2) } -- rest are arguments
    table.insert(funcs, creator(unpack(args)))
  end

  -- Return a function that calls them all
  return function(...)
    local results = {}
    for i, f in ipairs(funcs) do
      results[i] = f(...)
    end
    return unpack(results)
  end
end

return M
