local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local Path = require 'plenary.path'

-- File where projects are saved
local projects_file = vim.fn.stdpath 'data' .. '/projects.json'

-- Load projects from file
local function load_projects()
  local file = Path:new(projects_file)
  if not file:exists() then
    return {}
  end
  local content = vim.fn.readfile(projects_file)
  if vim.tbl_isempty(content) then
    return {}
  end
  local ok, data = pcall(vim.fn.json_decode, table.concat(content, '\n'))
  if ok and type(data) == 'table' then
    return data
  else
    return {}
  end
end

-- Save projects to file
local function save_projects(projects)
  local json = vim.fn.json_encode(projects)
  vim.fn.writefile({ json }, projects_file)
end

-- Add a new project if it doesn't exist
local function add_project(name, path)
  local projects = load_projects()
  -- Check for duplicate by name
  for _, proj in ipairs(projects) do
    if proj.name == name then
      print 'Project with this name already exists!'
      return
    end
  end
  table.insert(projects, { name = name, path = path })
  save_projects(projects)
end

local function _projects()
  local projects = load_projects()
  pickers
    .new({}, {
      prompt_title = 'Projects',
      finder = finders.new_table {
        results = projects,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        -- Enter: open selected project
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection then
            vim.cmd('cd ' .. selection.value.path)
            print('cd into: ' .. selection.value.path)
          end
        end)

        -- Ctrl-a: add new project
        map('i', '<C-a>', function()
          actions.close(prompt_bufnr)
          local name = ''
          while name == '' do
            name = vim.fn.input 'Project name: '
          end

          local path = ''
          while path == '' do
            path = vim.fn.input('Project path: ', '', 'dir')
          end

          add_project(name, path)
          print('Added project: ' .. name .. ' -> ' .. path)
        end)

        return true
      end,
    })
    :find()
end

return _projects
