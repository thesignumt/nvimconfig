vim.o.shell = 'pwsh'
vim.o.shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command'
vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
vim.o.shellpipe = '2>&1 | Tee-Object -FilePath %s; exit $LastExitCode'
vim.o.shellquote = ''
vim.o.shellxquote = ''

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = true,
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
    auto_scroll = true,
    float_opts = {
      border = 'single',
      winblend = 0,
      -- highlights = { border = "Normal", background = "Normal" },  -- optional in newer versions
    },
    -- new hooks (if supported)
    on_open = nil,
    on_close = nil,
    on_create = nil,
    on_stdout = nil,
  },
  config = function(_, opts)
    local toggleterm = require 'toggleterm'
    toggleterm.setup(opts)

    -- local Terminal = require('toggleterm.terminal').Terminal

    -- Lazygit terminal
    -- local lazygit = Terminal:new {
    --   cmd = 'lazygit',
    --   hidden = true,
    --   direction = 'float',
    --   float_opts = {
    --     border = 'rounded',
    --   },
    --   on_open = function(term)
    --     vim.cmd 'startinsert!'
    --     vim.api.nvim_buf_set_keymap(
    --       term.bufnr,
    --       't',
    --       'q',
    --       '<cmd>close<CR>',
    --       { noremap = true, silent = true }
    --     )
    --   end,
    -- }

    -- function _lazygit_toggle()
    --   lazygit:toggle()
    -- end

    local nmap = require('utils.map').nmap
    local rhs = {
      float = ':ToggleTerm direction=float<cr>',
      hor = ':ToggleTerm size=10 direction=horizontal<cr>',
      ver = ':ToggleTerm size=80 direction=vertical<cr>',
      tt = ':ToggleTerm<cr>',
    }

    -- ToggleTerm basics
    nmap('<leader>tf', rhs.float, 'float term')
    nmap('<leader>th', rhs.hor, 'hor term')
    nmap('<leader>tv', rhs.ver, 'ver term')
    nmap('<leader>tt', rhs.tt, 'toggleterm')

    -- Multiple terminals
    nmap('<leader>t1', ':1ToggleTerm<cr>', 'term 1')
    nmap('<leader>t2', ':2ToggleTerm<cr>', 'term 2')
    nmap('<leader>t3', ':3ToggleTerm<cr>', 'term 3')
    nmap('<leader>ta', ':ToggleTermToggleAll<cr>', 'all terms')

    -- Lazygit shortcut (uncomment if using)
    -- nmap('<leader>gg', '<cmd>lua _lazygit_toggle()<CR>')
  end,
}
