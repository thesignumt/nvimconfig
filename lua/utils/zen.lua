local zen_mode = require 'zen-mode'

local Zen = {}
Zen.__index = Zen

function Zen.new()
  return setmetatable({ active = false, orig_opts = {} }, Zen)
end

-- +-------------------------------------------------------+
-- [                     save options                      ]
-- +-------------------------------------------------------+
function Zen:save_opts()
  if next(self.orig_opts) then
    return
  end
  local o = self.orig_opts
  o.wrap = vim.wo.wrap
  o.number = vim.wo.number
  o.rnu = vim.wo.rnu
  o.colorcolumn = vim.wo.colorcolumn
end

-- +-------------------------------------------------------+
-- [                    restore options                    ]
-- +-------------------------------------------------------+
function Zen:restore_opts()
  local o = self.orig_opts
  vim.wo.wrap = o.wrap
  vim.wo.number = o.number
  vim.wo.rnu = o.rnu
  vim.wo.colorcolumn = o.colorcolumn
end

-- +-------------------------------------------------------+
-- [                      toggle zen                       ]
-- +-------------------------------------------------------+
function Zen:toggle(settings)
  settings = settings or {}
  local defaults =
    { width = 90, wrap = false, number = false, rnu = false, colorcolumn = '0' }
  for k, v in pairs(defaults) do
    if settings[k] == nil then
      settings[k] = v
    end
  end

  zen_mode.setup { window = { width = settings.width, options = {} } }

  if not self.active then
    self:save_opts()
    vim.wo.wrap = settings.wrap
    vim.wo.number = settings.number
    vim.wo.rnu = settings.rnu
    vim.wo.colorcolumn = settings.colorcolumn
  else
    self:restore_opts()
  end

  zen_mode.toggle()
  self.active = not self.active
end

-- +-------------------------------------------------------+
-- [                        presets                        ]
-- +-------------------------------------------------------+
function Zen:zen()
  self:toggle { width = 90, wrap = false, number = true, rnu = true }
end

function Zen:ZEN()
  self:toggle {
    width = 80,
    wrap = false,
    number = false,
    rnu = false,
    colorcolumn = '0',
  }
end

return Zen
