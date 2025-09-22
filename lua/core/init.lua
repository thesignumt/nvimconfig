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

require('utils.highlight').setup()

local pick = require 'utils.pick'
nmap('<leader>sc', pick.colorscheme, 'colorscheme')

require('utils.escape').setup {}
