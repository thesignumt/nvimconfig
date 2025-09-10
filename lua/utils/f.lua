local M = {}

M.fun = function(t)
  local f = t[1]
  local args = { unpack(t, 2) }
  return function()
    return f(unpack(args))
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

-- Multiple function creators
---@param ... table
---@return function
M.fns = function(...)
  local tables = { ... }

  -- Prepare all functions
  local funcs = {}
  for _, tbl in ipairs(tables) do
    local creator = tbl[1] -- first element is the function creator
    local args = { table.unpack(tbl, 2) } -- rest are arguments
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
