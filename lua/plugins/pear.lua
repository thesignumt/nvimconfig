local modes = require('utils.map').modes

return {
    -- {
    --   'sylvanfranklin/pear',
    --   config = function()
    --     local pear = require 'pear'
    --     nmap('<leader>b', pear.jump_pair, 'pear')
    --   end,
    -- },
    {
        'jakemason/ouroboros',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {},
        config = function(_, opts)
            local ouroboros = require 'ouroboros'
            ouroboros.setup(opts)

            vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'c', 'cpp' },
                callback = function()
                    modes('ni', '<C-e>', ouroboros.switch, 'switch hdr & impl', { buffer = true })
                end,
            })
        end,
    },
}
