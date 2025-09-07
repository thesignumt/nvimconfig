local M = {}
local conf = {
  cmd = true,
}

---Setup GoToGH user preferences
---@param opts any
function M.setup(opts)
  for k, v in pairs(opts or {}) do
    conf[k] = v
  end
end

function M.go()
  local line = vim.api.nvim_get_current_line()

  -- Pattern: capture user/repo inside single or double quotes
  local pattern = [['"]([%w_.-]+/[%w_.-]+)%1']]

  -- Try to find a match
  local match = line:match(pattern)

  if match then
    local url = 'https://github.com/' .. match
    print('Opening: ' .. url)

    -- Open in default browser (cross-platform)
    local open_cmd
    if vim.fn.has 'win32' == 1 then
      open_cmd = 'start "" "' .. url .. '"'
    elseif vim.fn.has 'macunix' == 1 then
      open_cmd = 'open "' .. url .. '"'
    else
      open_cmd = 'xdg-open "' .. url .. '"'
    end

    -- Execute the open command safely
    local ok, err = pcall(os.execute, open_cmd)
    if not ok then
      print('Failed to open URL: ' .. (err or 'unknown error'))
    end
  else
    print 'No GitHub repo found on the current line.'
  end
end

return M
