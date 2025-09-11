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
local fn = require('utils.f').fn

local def = require 'utils.def'
def.setup {}
nmap('<leader>iw', fn(def.lookup, 'word'), 'word def')
nmap('<leader>is', fn(def.lookup, 'lookup'), 'search word def')

local gotogh = require 'utils.gotogh'
gotogh.setup {}
nmap('gG', gotogh.go, 'go to github')
