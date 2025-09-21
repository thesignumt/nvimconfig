-- +-------------------------------------------------------+
-- [                         core                          ]
-- +-------------------------------------------------------+
require 'core.opts'
require 'core.lazy'
require 'core.remaps'
require 'core.cmds'
require 'core.genor'
require 'core.snippets'
require 'core.typst'

-- +-------------------------------------------------------+
-- [                      utils setup                      ]
-- +-------------------------------------------------------+
local nmap = require('utils.map').nmap

local comfy_lineno = require 'utils.comfy_lineno'
nmap('<leader>1', comfy_lineno.toggle_line_numbers, 'comfy lineno')

require('utils.highlight').setup()

local pick = require 'utils.pick'
nmap('<leader>sc', pick.colorscheme, 'colorscheme')
