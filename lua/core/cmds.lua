vim.api.nvim_create_user_command('ListPlugins', function()
  local home = vim.uv.os_homedir()
  local filepath = home .. '\\lazy_plugins.txt' -- Windows path

  local f = io.open(filepath, 'w')
  if f then
    for _, p in pairs(require('lazy').plugins()) do
      f:write(p.name .. '\n')
    end
    f:close()
    print('Plugin list written to: ' .. filepath)
  else
    print 'Error: could not write file'
  end
end, {})

-- vim.api.nvim_create_user_command('ClrShada', function()
--   local job_id =
--     vim.fn.jobstart 'powershell -c "Get-ChildItem ~\\AppData\\Local\\nvim-data\\shada | Where-Object {$_.Name -like \'*.tmp*\' } | Remove-Item -Recurse -Force"'
-- end, {})
