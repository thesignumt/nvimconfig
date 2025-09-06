require 'core.remaps'
require 'core.cmds'
require 'core.genor'
require 'core.snippets'
require 'core.typst'

local dblL = '<leader><leader>'
local m = require 'utils.map'
local nmap = m.nmap
local mkcmt = require 'utils.mkcmt'

mkcmt.setup {}
nmap(dblL .. 'c', mkcmt.comment)
