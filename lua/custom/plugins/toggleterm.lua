vim.o.shell = 'pwsh'
vim.o.shellcmdflag =
  '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
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
      border = 'rounded',
      winblend = 0,
      highlights = {
        border = 'FloatBorder:CmpBorder',
        background = 'Normal',
      },
    },
  },

  config = function(_, opts)
    require('toggleterm').setup(opts)

    local Terminal = require('toggleterm.terminal').Terminal

    -- Lazygit terminal
    local lazygit = Terminal:new {
      cmd = 'lazygit',
      hidden = true,
      direction = 'float',
      float_opts = {
        border = 'rounded',
      },
      on_open = function(term)
        vim.cmd 'startinsert!'
        -- optional: map 'q' inside lazygit to close terminal
        vim.api.nvim_buf_set_keymap(
          term.bufnr,
          't',
          'q',
          '<cmd>close<CR>',
          { noremap = true, silent = true }
        )
      end,
    }

    function _lazygit_toggle()
      lazygit:toggle()
    end

    -- Keymaps
    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }

    -- ToggleTerm basics
    map('n', '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', opts)
    map(
      'n',
      '<leader>th',
      '<cmd>ToggleTerm size=10 direction=horizontal<cr>',
      opts
    )
    map(
      'n',
      '<leader>tv',
      '<cmd>ToggleTerm size=80 direction=vertical<cr>',
      opts
    )
    map('n', '<leader>tt', '<cmd>ToggleTerm<cr>', opts)

    -- Multiple terminals
    map('n', '<leader>t1', '<cmd>1ToggleTerm<cr>', opts)
    map('n', '<leader>t2', '<cmd>2ToggleTerm<cr>', opts)
    map('n', '<leader>t3', '<cmd>3ToggleTerm<cr>', opts)
    map('n', '<leader>ta', '<cmd>ToggleTermToggleAll<cr>', opts)

    -- Lazygit shortcut
    map('n', '<leader>gg', '<cmd>lua _lazygit_toggle()<CR>', opts)
  end,
}
