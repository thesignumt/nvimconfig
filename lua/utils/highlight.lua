local M = {}

function M.setup()
  local function apply()
    vim.api.nvim_set_hl(0, 'CmpBorder', { fg = '#20f6e2', bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'CmpDocBorder', { fg = '#20f6e2', bg = 'NONE' })
  end

  -- apply once on startup
  apply()

  -- reapply every time colorscheme changes
  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = apply,
  })
end

return M
