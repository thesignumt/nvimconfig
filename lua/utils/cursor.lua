---@diagnostic disable: param-type-mismatch

---@class Cursor
---@field cursors string[] List of cursor styles
---@field index integer Current active index
---@field default_index integer Index used as default when starting
---@field default_file string File path for storing default index
---@field count integer Number of available cursors
local Cursor = {}
Cursor.__index = Cursor

---@param opts {cursors: string[]?, default_index: integer?}?
---@return Cursor
function Cursor.new(opts)
  opts = opts or {}
  vim.validate('opts.cursors', opts.cursors, 'string[]', true)
  vim.validate('opts.default_index', opts.default_index, 'integer', true)
  local self = setmetatable({
    cursors = opts.cursors
      or { 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20', '' },
    index = 1,
    default_file = vim.fn.stdpath 'data' .. '/cursor_default', -- persistent file
    default_index = opts.default_index or 1,
  }, Cursor)

  self.count = #self.cursors

  self:_load_default()
  self:set(self.default_index, { silent = false })

  return self
end

---validate index
---@param index integer
function Cursor:_validate_index(index)
  if index < 1 or index > self.count then
    error(('Index %d out of range (1-%d)'):format(index, self.count))
  end
end

---get current cursor
---@return string c_cursor
function Cursor:current()
  return self.cursors[self.index]
end

---Set the cursor to a specific index
---@param index integer
---@param opts {silent: boolean, setdefault: boolean}?
function Cursor:set(index, opts)
  self:_validate_index(index)
  self.index = index
  local current = self:current()
  vim.opt.guicursor = current

  ---@diagnostic disable-next-line: redefined-local
  local opts =
    vim.tbl_extend('force', { silent = false, setdefault = false }, opts or {})
  local silent, setdefault = opts.silent, opts.setdefault
  local is_default = index == self.default_index and ' -- DEFAULT --' or ''
  if not silent then
    print(("%d -> '%s' %s"):format(self.index, current, is_default))
  end

  if setdefault then
    self.default_index = self.index
    self:_save_default()
  end
end

---Toggle to the next cursor in the list (cycles automatically)
---@param opts {silent: boolean, setdefault: boolean}?
function Cursor:toggle(opts)
  self:set((self.index % self.count) + 1, opts)
end

---Set the default cursor index for future sessions
---@param index integer
function Cursor:_setdefault(index)
  self:_validate_index(index)
  self.default_index = index
  self:_save_default()
  -- print(('Default cursor set to index %d'):format(index))
end

---Save the default index to file
function Cursor:_save_default()
  local fd, err = vim.uv.fs_open(self.default_file, 'w', 420) -- 0644
  if not fd then
    vim.notify('Failed to write data: ' .. err, vim.log.levels.ERROR)
    return
  end

  local ok, write_err =
    pcall(vim.uv.fs_write, fd, tostring(self.default_index), -1)

  vim.uv.fs_close(fd) -- always close

  if not ok then
    vim.notify(
      'Failed to write cursor default: ' .. (write_err or ''),
      vim.log.levels.ERROR
    )
  end
end

---Load the default index from file
function Cursor:_load_default()
  local fd, _ = vim.uv.fs_open(self.default_file, 'r', 420)
  if not fd then
    return
  end

  local stat = vim.uv.fs_fstat(fd)
  if not stat then
    vim.uv.fs_close(fd)
    return
  end

  local ok, data = pcall(function()
    return vim.uv.fs_read(fd, stat.size, 0)
  end)

  vim.uv.fs_close(fd) -- always close

  if not ok or not data then
    vim.notify('Failed to read cursor_default', vim.log.levels.WARN)
    return
  end

  local idx = tonumber(data)
  if idx and idx >= 1 and idx <= self.count then
    self.default_index = idx
  end
end

---Add a new cursor style to the list
---@param style string
function Cursor:add(style)
  table.insert(self.cursors, style)
  self.count = #self.cursors
end

---Remove a cursor style by index
---@param index integer
function Cursor:remove(index)
  self:_validate_index(index)
  table.remove(self.cursors, index)
  self.count = #self.cursors
  -- adjust index if it pointed past end
  if self.index > self.count then
    self.index = self.count
  end
  -- adjust default if needed
  if self.default_index > self.count then
    self.default_index = self.count
    self:_save_default()
  end
end

---Replace a cursor style at a given index
---@param index integer
---@param style string
function Cursor:replace(index, style)
  self:_validate_index(index)
  self.cursors[index] = style
end

return Cursor
