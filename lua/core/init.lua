require 'core.remaps'
require 'core.cmds'
require 'core.genor'
require 'core.snippets'
require 'core.typst'

local m = require 'utils.map'
local nmap = m.nmap
local dblL = '<leader><leader>'
local mkcmt = require 'utils.mkcmt'

mkcmt.setup {}
nmap(dblL .. 'c', mkcmt.comment)
