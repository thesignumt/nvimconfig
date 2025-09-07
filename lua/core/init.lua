-- +-------------------------------------------------------+
-- [                         core                          ]
-- +-------------------------------------------------------+
require 'core.remaps'
require 'core.cmds'
require 'core.genor'
require 'core.snippets'
require 'core.typst'

-- +-------------------------------------------------------+
-- [                      utils setup                      ]
-- +-------------------------------------------------------+
local nmap = require('utils.map').nmap
local gotogh = require 'utils.gotogh'

gotogh.setup {}
nmap('gG', gotogh.go, 'go to github')
