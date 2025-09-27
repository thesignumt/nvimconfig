---Set the colorscheme by parameter or pick using Telescope
---@param theme string?
local function colorscheme(theme)
  ---@class Theme
  ---@field name string
  ---@field callback? fun(): nil

  ---@type Theme[]
  local Themes = {
    {
      name = 'tokyonight-night',
    },
    {
      name = 'rose-pine-moon',
    },
    {
      name = 'vague',
    },
  }

  vim.validate('theme', theme, 'string', true)

  local function apply_theme(entry)
    vim.cmd.colorscheme(entry.name)
    if entry.callback then
      entry.callback()
    else
      vim.notify('colorscheme: ' .. entry.name, vim.log.levels.INFO)
    end
  end

  if theme then
    for _, v in ipairs(Themes) do
      if v.name == theme then
        return apply_theme(v)
      end
    end
    vim.notify(
      ("Colorscheme '%s' not found!"):format(theme),
      vim.log.levels.WARN
    )
    return
  end

  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local sorters = require('telescope.config').values.generic_sorter
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  pickers
    .new({}, {
      prompt_title = 'Select Colorscheme',
      finder = finders.new_table {
        results = Themes,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      },
      sorter = sorters(),
      attach_mappings = function(_, map)
        local function select_colorscheme(prompt_bufnr)
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if entry then
            apply_theme(entry.value)
          end
        end

        map('i', '<CR>', select_colorscheme)
        map('n', '<CR>', select_colorscheme)
        return true
      end,
    })
    :find()
end

return colorscheme
