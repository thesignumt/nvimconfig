local M = {}

function M.colorscheme()
  local themes = {
    'tokyonight-night',
    'rose-pine-moon',
    'vague',
  }

  require('telescope.pickers')
    .new({}, {
      prompt_title = 'Select Colorscheme',
      finder = require('telescope.finders').new_table {
        results = themes,
      },
      sorter = require('telescope.config').values.generic_sorter {},
      attach_mappings = function(_, map)
        local actions = require 'telescope.actions'
        local action_state = require 'telescope.actions.state'

        local select_colorscheme = function(prompt_bufnr)
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

return M
