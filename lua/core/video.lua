local fn = require('utils.f').fn

local Job = require 'plenary.job'
local recording_job = nil

local function ensure_dir(path)
  vim.fn.mkdir(vim.fn.expand(path), 'p')
end
---full path
local function fpath(dir, filename)
  return vim.fn.fnamemodify(vim.fn.expand(dir .. '/' .. filename), ':p')
end
local function unique_filename(base, ext)
  local counter = 1
  local name = base .. ext
  -- Check if the file exists; if yes, add a numeric suffix
  while vim.fn.filereadable(name) == 1 do
    name = ('%s(%d)%s'):format(base, counter, ext)
    counter = counter + 1
  end
  return name
end

---start recording
---@param hq boolean high quality
local function start_record(hq)
  ensure_dir '~/Videos/nvim'
  local current_file = vim.fn.expand '%:t'
  local time = os.date '%H-%M'
  local suffix = hq and '_hq' or ''
  local base =
    fpath('~/Videos/nvim', ('%s(%s)%s'):format(current_file, time, suffix))
  local full_path = unique_filename(base, '.mp4')

  local args = {
    '-y',
    '-f',
    'dshow',
    '-i',
    'video=screen-capture-recorder',
    '-framerate',
    '60',
    '-filter:v',
    hq and 'crop=1920:1080:(in_w-1920)/2:(in_h-1080)/2,unsharp=7:7:1.0:7:7:0.0'
      or 'crop=1920:1080:(in_w-1920)/2:(in_h-1080)/2,unsharp=5:5:1.0:5:5:0.0',
    '-c:v',
    'libx264',
    '-pix_fmt',
    'yuv420p',
  }

  if hq then
    table.insert(args, '-crf')
    table.insert(args, '18')
    table.insert(args, '-preset')
    table.insert(args, 'fast')
  else
    table.insert(args, '-preset')
    table.insert(args, 'ultrafast')
  end

  table.insert(args, full_path)

  recording_job = Job:new { command = 'ffmpeg', args = args, hide = true }
  recording_job:start()
  print((hq and 'High quality ' or '') .. 'Recording to: ' .. full_path)
end

local aesthetic_record = fn(start_record, false)
local aesthetic_record_hq = fn(start_record, true)

local function aesthetic_screenshot()
  ensure_dir '~/Videos/nvimPhotos'

  local current_file = vim.fn.expand '%:t'
  local time = os.date '%H-%M'
  local base =
    fpath('~/Videos/nvimPhotos', ('%s(%s)'):format(current_file, time))
  local full_path = unique_filename(base, '.png')

  local job = Job:new {
    command = 'ffmpeg',
    args = {
      '-y',
      '-f',
      'gdigrab',
      '-i',
      'desktop',
      '-frames:v',
      '1',
      '-filter:v',
      'crop=1920:1080:(in_w-1920)/2:(in_h-1080)/2,unsharp=5:5:1.0:5:5:0.0',
      full_path,
    },
    hide = true, -- hides the console window
    on_exit = function(j, return_val)
      if return_val == 0 then
        vim.schedule(function()
          vim.notify('Screenshot saved to: ' .. full_path, vim.log.levels.INFO)
        end)
      else
        local result = table.concat(j:result(), '\n')
        vim.schedule(function()
          vim.notify(
            'Failed to take screenshot:\n' .. result,
            vim.log.levels.ERROR
          )
        end)
      end
    end,
  }

  job:start()
end

local function stop_record()
  if recording_job and recording_job:is_running() then
    -- graceful stop: send 'q' and wait for ffmpeg to finish
    recording_job:send 'q\n'
    recording_job:shutdown 'wait'
    recording_job = nil
    print 'Recording stopped.'
  else
    print 'No active recording!'
  end
end

vim.api.nvim_create_user_command('Screenshot', aesthetic_screenshot, {})
vim.api.nvim_create_user_command('RecordStop', stop_record, {})
vim.api.nvim_create_user_command('Record', aesthetic_record, {})
vim.api.nvim_create_user_command('RecordHQ', aesthetic_record_hq, {})

local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

local recording_actions = {
  'Screenshot',
  'RecordStop',
  'Record',
  'RecordHQ',
}

local function record_picker()
  pickers
    .new({}, {
      prompt_title = 'Recording Actions',
      finder = finders.new_table {
        results = recording_actions,
      },
      sorter = conf.generic_sorter {},
      ---@diagnostic disable-next-line: unused-local
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection and selection.value then
            vim.cmd(selection.value)
          else
            vim.notify('No selection made!', vim.log.levels.WARN)
          end
        end)
        return true
      end,
    })
    :find()
end

vim.api.nvim_create_user_command('RecordPicker', record_picker, {})

local nmap = require('utils.map').nmap
nmap('<leader><leader>r', aesthetic_record, 'record')
nmap('<leader><leader>t', aesthetic_record_hq, 'record: hq')
nmap('<leader><leader>R', stop_record, 'stop recording')
nmap('<leader><leader>s', aesthetic_screenshot, 'screenshot')
