local M = {}

function M.setup()
  local function apply()
    -- border
    vim.api.nvim_set_hl(0, 'ThesignumtBd', { fg = '#8dbcff', bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'ThesignumtDocBd', { fg = '#8dbcff', bg = 'NONE' })
  end

  apply()

  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = apply,
  })
end

return M
