return {
    'danymat/neogen',
    opts = {
        snippet_engine = 'luasnip',
    },
    version = '*', -- stable versions only
    config = function(_, opts)
        require('neogen').setup(opts)
    end,
}
