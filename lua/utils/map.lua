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

--- safely map keymaps
--- @param mode string|string[] Mode(s) to set remaps to.
--- @param lhs string left-hand side of the mapping.
--- @param rhs string|function right-hand side of the mapping, can be a Lua function.
--- @param desc_or_opts? string|vim.keymap.set.Opts
--- @param opts? vim.keymap.set.Opts
function M.map(mode, lhs, rhs, desc_or_opts, opts)
  vim.validate('mode', mode, { 'string', 'table' })
  vim.validate('lhs', lhs, 'string')
  vim.validate('rhs', rhs, { 'string', 'function' })
  vim.validate('desc_or_opts', desc_or_opts, { 'string', 'table' }, true)
  vim.validate('opts', opts, 'table', true)

  ---@cast mode string[]
  mode = type(mode) == 'string' and { mode } or mode

  local base_opts = vim.tbl_extend(
    'force',
    opts or { noremap = true, silent = true },
    type(desc_or_opts) == 'string' and { desc = desc_or_opts }
      or desc_or_opts
      or {}
  )

  for _, m in ipairs(mode) do
    pcall(vim.keymap.set, m, lhs, rhs, vim.deepcopy(base_opts, true))
  end
end

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

function M.modes(mode_str, lhs, rhs, text_or_opts, opts)
  -- check_type(mode_str, 'string', 'mode_str')
  -- check_type(lhs, 'string', 'lhs')
  -- check_type(rhs, 'string_or_fun', 'rhs')

  local modes = {}
  for c in mode_str:gmatch '.' do
    table.insert(modes, c)
  end

  M.map(modes, lhs, rhs, text_or_opts, opts)
end

return M
