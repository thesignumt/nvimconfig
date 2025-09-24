---@class Cursor
---@field cursors string[] List of cursor styles
---@field index integer Current active index
---@field default_index integer Index used as default when starting
---@field default_file string File path for storing default index
---@field count integer Number of available cursors
local Cursor = {}
Cursor.__index = Cursor

---@param cursors string[]? List of cursor styles
---@return Cursor
function Cursor.new(cursors)
  local self = setmetatable({
    cursors = cursors or { 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20', '' },
    index = 1,
    default_file = vim.fn.stdpath 'data' .. '/cursor_default', -- persistent file
    default_index = 1,
  }, Cursor)

  -- Load default index from file
  self:_load_default()
  self:set(self.default_index, { show = false })

  return self
end

---Set the cursor to a specific index
---@param index integer
---@param opts {show: boolean, setdefault: boolean}? Optional: show print and set as default
function Cursor:set(index, opts)
  if index < 1 or index > #self.cursors then
    error(('Index %d out of range (1-%d)'):format(index, #self.cursors))
  end

  self.index = index
  local current = self.cursors[self.index]
  vim.opt.guicursor = current

  opts = opts or {}
  local show = opts.show ~= nil and opts.show or true
  local is_default = index == self.default_index and ' -- DEFAULT --' or ''
  if show then
    print(("%d -> '%s' %s"):format(self.index, current, is_default))
  end

  -- Set as default if requested
  if opts.setdefault then
    self.default_index = self.index
    self:_save_default()
  end
end

---Toggle to the next cursor in the list (cycles automatically)
---@param opts {show: boolean, setdefault: boolean}? Optional: show print and set as default
function Cursor:toggle(opts)
  local next_index = (self.index % #self.cursors) + 1
  self:set(next_index, opts)
end

---Set the default cursor index for future sessions
---@param index integer
function Cursor:_setdefault(index)
  if index < 1 or index > #self.cursors then
    error(('Index %d out of range (1-%d)'):format(index, #self.cursors))
  end
  self.default_index = index
  self:_save_default()
  -- print(('Default cursor set to index %d'):format(index))
end

---Save the default index to file
function Cursor:_save_default()
  local f = io.open(self.default_file, 'w')
  if not f then
    vim.notify('Failed to write cursor default file', vim.log.levels.ERROR)
    return
  end
  f:write(tostring(self.default_index))
  f:close()
end

---Load the default index from file
function Cursor:_load_default()
  local f = io.open(self.default_file, 'r')
  if f then
    local content = f:read '*l'
    f:close()
    local idx = tonumber(content)
    if idx and idx >= 1 and idx <= #self.cursors then
      self.default_index = idx
    end
  end
end

return Cursor
