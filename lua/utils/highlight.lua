local M = {}

function M.setup()
  local function apply()
    -- border
    vim.api.nvim_set_hl(0, 'ThesignumtBd', { fg = '#20f6e2', bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'ThesignumtDocBd', { fg = '#20f6e2', bg = 'NONE' })

    -- spell
    vim.api.nvim_set_hl(0, 'SpellBad', { undercurl = true, sp = '#ff0000' }) -- red squiggly
    vim.api.nvim_set_hl(0, 'SpellCap', { undercurl = true, sp = '#ffa500' }) -- orange squiggly for capitalized
    vim.api.nvim_set_hl(0, 'SpellLocal', { undercurl = true, sp = '#1e90ff' }) -- blue squiggly
    vim.api.nvim_set_hl(0, 'SpellRare', { undercurl = true, sp = '#800080' }) -- purple squiggly
  end

  apply()

  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = apply,
  })
end

return M
