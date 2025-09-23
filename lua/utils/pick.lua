local Pick = {}

---Set the colorscheme by parameter or pick using Telescope
---@param theme string?
function Pick.colorscheme(theme)
  local themes = {
    'tokyonight-night',
    'rose-pine-moon',
    'vague',
  }

  vim.validate('theme', theme, 'string', true)

  if theme then
    for _, v in ipairs(themes) do
      if v == theme then
        return vim.cmd.colorscheme(v)
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
      finder = finders.new_table { results = themes },
      sorter = sorters(),
      attach_mappings = function(_, map)
        local function select_colorscheme(prompt_bufnr)
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if entry then
            vim.cmd.colorscheme(entry[1])
          end
        end

        map('i', '<CR>', select_colorscheme)
        map('n', '<CR>', select_colorscheme)
        return true
      end,
    })
    :find()
end

return Pick
