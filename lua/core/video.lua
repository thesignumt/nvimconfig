local Job = require 'plenary.job'

local recording_job = nil

local function ensure_dir(path)
  vim.fn.mkdir(vim.fn.expand(path), 'p')
end

local function aesthetic_record()
  ensure_dir '~/Videos/nvim'

  local current_file = vim.fn.expand '%:t'
  local time = os.date '%H-%M'
  local output_filename = string.format('%s(%s).mp4', current_file, time)
  local full_path =
    vim.fn.fnamemodify(vim.fn.expand('~/Videos/nvim/' .. output_filename), ':p')

  recording_job = Job:new {
    command = 'ffmpeg',
    args = {
      '-y',
      '-f',
      'dshow',
      '-i',
      'video=screen-capture-recorder',
      '-framerate',
      '60',
      '-filter:v',
      'crop=1920:1080:(in_w-1920)/2:(in_h-1080)/2,unsharp=5:5:1.0:5:5:0.0',
      '-c:v',
      'libx264',
      '-pix_fmt',
      'yuv420p',
      '-preset',
      'ultrafast',
      full_path,
    },
    hide = true,
  }

  recording_job:start()
  print('Recording to: ' .. full_path)
end

local function aesthetic_screenshot()
  ensure_dir '~/Videos/nvimPhotos'

  local current_file = vim.fn.expand '%:t'
  local time = os.date '%H-%M'
  local output_filename = string.format('%s(%s).png', current_file, time)
  local full_path = vim.fn.fnamemodify(
    vim.fn.expand('~/Videos/nvimPhotos/' .. output_filename),
    ':p'
  )

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

local function aesthetic_record_hq()
  ensure_dir '~/Videos/nvim'

  local current_file = vim.fn.expand '%:t'
  local time = os.date '%H-%M'
  local output_filename = string.format('%s(%s)_hq.mp4', current_file, time)
  local full_path =
    vim.fn.fnamemodify(vim.fn.expand('~/Videos/nvim/' .. output_filename), ':p')

  recording_job = Job:new {
    command = 'ffmpeg',
    args = {
      '-y',
      '-f',
      'dshow',
      '-i',
      'video=screen-capture-recorder',
      '-framerate',
      '60',
      '-filter:v',
      'crop=1920:1080:(in_w-1920)/2:(in_h-1080)/2,unsharp=7:7:1.0:7:7:0.0',
      '-c:v',
      'libx264',
      '-crf',
      '18',
      '-preset',
      'fast',
      '-pix_fmt',
      'yuv420p',
      full_path,
    },
    hide = true,
  }

  recording_job:start()
  print('High quality recording to: ' .. full_path)
end

local function stop_record()
  if recording_job then
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
      prompt_title = 'Select Recording Action',
      finder = finders.new_table {
        results = recording_actions,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local cmd = selection[1]
          if cmd then
            vim.cmd(cmd)
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
