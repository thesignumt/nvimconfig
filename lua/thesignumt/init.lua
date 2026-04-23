require 'thesignumt.set'
require 'thesignumt.lazy_init'
require 'thesignumt.remap'
require 'thesignumt.cmds'
require 'thesignumt.snippets'
require 'thesignumt.video'

require('thesignumt.utils.highlight').setup()

vim.filetype.add { extension = { h = 'c' } }

vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            completion = { callSnippet = 'Replace' },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                ignoreDir = {
                    '.git',
                    'dist',
                    'build',
                    '.cache',
                },
                library = {
                    vim.env.VIMRUNTIME,
                },
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})
