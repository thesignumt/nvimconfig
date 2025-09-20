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

require('utils.highlight').setup()
-- require('utils.todo').setup { target_file = '~/notes/todo.md' }
