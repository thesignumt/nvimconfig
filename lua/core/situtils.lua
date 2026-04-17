local M = {}
local Job = require 'plenary.job'
local Terminal = require('toggleterm.terminal').Terminal
local fmt = string.format
local uv = vim.uv or vim.loop

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = 'situtils' })
end
local function notify_err(msg)
  notify(msg, vim.log.levels.ERROR)
end
local function notify_warn(msg)
  notify(msg, vim.log.levels.WARN)
end

function M.fetch_raw_url()
  local input = vim.fn.input 'Raw URL: '
  input = vim.trim(input or '')
  if input == '' then
    return
  end

  local filename = input:match '.*/([^/?]+)' or 'downloaded_file'
  filename = filename:gsub('[<>:"/\\|?*]', '_')

  Job:new({
    command = 'wget',
    args = { '-q', '-O', filename, input },
    on_exit = function(j, return_val)
      vim.schedule(function()
        if return_val ~= 0 then
          local err_msg = table.concat(j:stderr_result(), '\n')
          if err_msg == '' then
            err_msg = 'unknown error'
          end
          notify_err('wget failed: ' .. err_msg)
        else
          notify('wget worked: ' .. filename)
        end
      end)
    end,
  }):start()
end

function M.open_git_origin()
  local path = uv.cwd()

  -- Walk up directories to find .git
  while path ~= '/' do
    local git_path = path .. '/.git'
    local stat = uv.fs_stat(git_path)
    if stat and stat.type == 'directory' then
      -- Read origin URL from .git/config
      local config_path = git_path .. '/config'
      local file = io.open(config_path, 'r')
      if file then
        local url
        for line in file:lines() do
          url = line:match '^%s*url%s*=%s*(.+)'
          if url then
            break
          end
        end
        file:close()
        if url then
          -- Normalize SSH URLs to HTTPS
          url = url:gsub('^git@([^:]+):', 'https://%1/')
          url = url:gsub('%.git$', '')
          -- Open in default browser
          local open_cmd = nil
          if vim.fn.has 'mac' == 1 then
            open_cmd = 'open'
          elseif vim.fn.has 'win32' == 1 then
            open_cmd = 'cmd.exe /c start ""'
          else
            open_cmd = 'xdg-open'
          end
          os.execute(fmt('%s "%s"', open_cmd, url))
          notify('Opened Git origin' .. url)
          return
        end
      end
    end
    path = uv.fs_realpath(path .. '/..') or '/'
  end

  notify_err 'No .git folder found in parent directories.'
end

function M.wezterm_config()
  vim.cmd 'e ~/.config/wezterm/wezterm.lua'
end

function M.toggle_cmp()
  notify_warn 'notice: it is janky'
  local cmp = require 'cmp'

  if _G.cmp_enabled == nil then
    _G.cmp_enabled = true
  end

  _G.cmp_enabled = not _G.cmp_enabled

  cmp.setup {
    enabled = function()
      return _G.cmp_enabled
    end,
  }

  print('cmp ' .. (_G.cmp_enabled and 'enabled' or 'disabled'))
end

function M.pick()
  local ok, telescope = pcall(require, 'telescope')
  if not ok then
    vim.notify('Telescope not installed', vim.log.levels.ERROR)
    return
  end

  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  local func_names = {}
  for name, fn in pairs(M) do
    if type(fn) == 'function' and name:sub(1, 1) ~= '_' and name ~= 'pick' then
      func_names[#func_names + 1] = name
    end
  end

  local layout_config = {
    width = math.floor(vim.o.columns * 0.5),
    height = math.floor(vim.o.lines * 0.5),
    prompt_position = 'top',
  }

  pickers
    .new({}, {
      prompt_title = 'situtils menu',
      finder = finders.new_table { results = func_names },
      sorter = conf.generic_sorter(),
      layout_strategy = 'flex',
      layout_config = layout_config,
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local fn = M[selection.value]
          if fn then
            local ok, err = pcall(fn)
            if not ok then
              notify_err('Error calling function: ' .. err)
            end
          end
        end)
        return true
      end,
    })
    :find()
end

local function register_commands()
  -- automatically collect subcommands from M, like pick()
  local function get_subcommands()
    local cmds = {}
    for name, fn in pairs(M) do
      if
        type(fn) == 'function'
        and name:sub(1, 1) ~= '_'
        and name ~= 'pick'
      then
        cmds[name] = fn
      end
    end
    return cmds
  end

  vim.api.nvim_create_user_command('SUMenu', function(opts)
    local sub = vim.trim(opts.args or '')
    local subcommands = get_subcommands()

    if sub == '' then
      local ok, err = pcall(M.pick)
      if not ok then
        notify_err('Error running pick: ' .. err)
      end
      return
    end

    local fn = subcommands[sub]
    if not fn then
      notify_err('Unknown subcommand: ' .. sub)
      return
    end

    local ok, err = pcall(fn)
    if not ok then
      notify_err('Error running ' .. sub .. ': ' .. err)
    end
  end, {
    nargs = '?',
    complete = function()
      local subcommands = get_subcommands()
      return vim.tbl_keys(subcommands)
    end,
  })
end

register_commands()

return M
