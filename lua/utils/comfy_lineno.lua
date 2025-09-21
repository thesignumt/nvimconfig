local enabled = false

local DEFAULT_LABELS = {
  '1',
  '2',
  '3',
  '4',
  '5',
  '11',
  '12',
  '13',
  '14',
  '15',
  '21',
  '22',
  '23',
  '24',
  '25',
  '31',
  '32',
  '33',
  '34',
  '35',
  '41',
  '42',
  '43',
  '44',
  '45',
  '51',
  '52',
  '53',
  '54',
  '55',
  '111',
  '112',
  '113',
  '114',
  '115',
  '121',
  '122',
  '123',
  '124',
  '125',
  '131',
  '132',
  '133',
  '134',
  '135',
  '141',
  '142',
  '143',
  '144',
  '145',
  '151',
  '152',
  '153',
  '154',
  '155',
  '211',
  '212',
  '213',
  '214',
  '215',
  '221',
  '222',
  '223',
  '224',
  '225',
  '231',
  '232',
  '233',
  '234',
  '235',
  '241',
  '242',
  '243',
  '244',
  '245',
  '251',
  '252',
  '253',
  '254',
  '255',
}

local M = {
  config = {
    labels = DEFAULT_LABELS,
    up_key = 'k',
    down_key = 'j',
    hidden_file_types = { 'undotree' },
    hidden_buffer_types = { 'terminal', 'nofile' },
  },
}

local function should_hide_numbers(filetype, buftype)
  return vim.tbl_contains(M.config.hidden_file_types, filetype)
    or vim.tbl_contains(M.config.hidden_buffer_types, buftype)
end

-- Global function for statuscolumn
_G.get_label = function(absnum, relnum)
  if not enabled then
    -- When disabled, show relative line numbers
    if relnum == 0 then
      return ('%-2d'):format(vim.fn.line '.')
    else
      return ('%-2d'):format(relnum)
    end
  end

  if relnum == 0 then
    return ('%-2d'):format(vim.fn.line '.')
  elseif relnum > 0 and relnum <= #M.config.labels then
    return ('%-2s'):format(M.config.labels[relnum])
  else
    return ('%-2d'):format(absnum)
  end
end

local function update_status_column()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buftype = vim.bo[buf].buftype
    local filetype = vim.bo[buf].filetype

    vim.api.nvim_win_call(win, function()
      if should_hide_numbers(filetype, buftype) then
        vim.opt.statuscolumn = ''
      else
        vim.opt.statuscolumn = '%=%s%=%{v:lua.get_label(v:lnum, v:relnum)} '
      end
    end)
  end
end

local function manage_keymaps(enable_keys)
  for index, label in ipairs(M.config.labels) do
    local up_mapping = label .. M.config.up_key
    local down_mapping = label .. M.config.down_key

    if enable_keys then
      vim.keymap.set(
        { 'n', 'v', 'o' },
        up_mapping,
        index .. 'k',
        { noremap = true }
      )
      vim.keymap.set(
        { 'n', 'v', 'o' },
        down_mapping,
        index .. 'j',
        { noremap = true }
      )
    else
      pcall(vim.keymap.del, { 'n', 'v', 'o' }, up_mapping)
      pcall(vim.keymap.del, { 'n', 'v', 'o' }, down_mapping)
    end
  end
end

local function set_enabled_state(state)
  enabled = state
  manage_keymaps(enabled)
  update_status_column()
end

function M.enable_line_numbers()
  set_enabled_state(true)
end

function M.disable_line_numbers()
  set_enabled_state(false)
end

function M.toggle_line_numbers()
  set_enabled_state(not enabled)
end

local function create_auto_commands()
  local group =
    vim.api.nvim_create_augroup('ComfyLineNumbers', { clear = true })

  vim.api.nvim_create_autocmd(
    { 'WinNew', 'BufWinEnter', 'BufEnter', 'TermOpen' },
    {
      group = group,
      pattern = '*',
      callback = update_status_column,
    }
  )
end

local function create_user_command()
  vim.api.nvim_create_user_command('ComfyLineNumbers', function(args)
    local arg = args.args

    if arg == 'enable' then
      M.enable_line_numbers()
    elseif arg == 'disable' then
      M.disable_line_numbers()
    elseif arg == 'toggle' then
      M.toggle_line_numbers()
    else
      vim.notify(
        'ComfyLineNumbers: Invalid argument. Use enable, disable, or toggle.',
        vim.log.levels.ERROR
      )
    end
  end, {
    nargs = 1,
    complete = function()
      return { 'enable', 'disable', 'toggle' }
    end,
  })
end

---@param config table|nil
function M.setup(config)
  M.config = vim.tbl_deep_extend('force', M.config, config or {})

  vim.opt.relativenumber = true

  create_auto_commands()
  create_user_command()
  M.enable_line_numbers()
end

return M
