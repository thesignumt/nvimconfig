local M = {}

--- Safely unmap keys
---@param modes string|string[] Mode(s) to unmap, e.g., 'n' or {'n', 'v'}
---@param lhs string The key sequence to unmap
---@param opts? vim.keymap.del.Opts
function M.unmap(modes, lhs, opts)
  vim.validate('modes', modes, { 'string', 'table' })
  vim.validate('lhs', lhs, 'string')
  vim.validate('opts', opts, 'table', true)

  opts = opts or {}
  modes = type(modes) == 'string' and { modes } or modes
  --- @cast modes string[]

  for _, mode in ipairs(modes) do
    pcall(vim.keymap.del, mode, lhs, opts)
  end
end

function M.map(mode, lhs, rhs, text_or_opts, opts)
  check_type(mode, 'string_or_table', 'mode')
  check_type(lhs, 'string', 'lhs')
  check_type(rhs, 'string_or_fun', 'rhs')

  -- Handle flexible arguments
  local text
  if type(text_or_opts) == 'string' then
    text = text_or_opts
  elseif type(text_or_opts) == 'table' then
    opts = text_or_opts
    text = nil
  elseif text_or_opts ~= nil then
    error 'Expected text (string) or opts (table) as 4th parameter'
  end

  check_type(text, 'string_or_nil', 'text')
  check_type(opts, 'table_or_nil', 'opts')

  local options = { noremap = true, silent = true }
  if text then
    options.desc = text
  end
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end

  vim.keymap.set(mode, lhs, rhs, options)
end

-- Convenience functions
local function create_mapper(mode)
  return function(lhs, rhs, text_or_opts, opts)
    M.map(mode, lhs, rhs, text_or_opts, opts)
  end
end

M.nmap = create_mapper 'n'
M.imap = create_mapper 'i'
M.vmap = create_mapper 'v'
M.xmap = create_mapper 'x'
M.smap = create_mapper 's'
M.cmap = create_mapper 'c'
M.omap = create_mapper 'o'
M.tmap = create_mapper 't'

-- Map multiple modes from string like "nvx"
function M.modes(mode_str, lhs, rhs, text_or_opts, opts)
  check_type(mode_str, 'string', 'mode_str')
  check_type(lhs, 'string', 'lhs')
  check_type(rhs, 'string_or_fun', 'rhs')

  local mode_table = {}
  for c in mode_str:gmatch '.' do
    table.insert(mode_table, c)
  end

  M.map(mode_table, lhs, rhs, text_or_opts, opts)
end

return M
