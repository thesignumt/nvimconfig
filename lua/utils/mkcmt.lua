local M = {}
local config = {
  default_text = 'HELLO WORLD',
  min_width = 40, -- minimum width of the block
  padding = 6, -- extra spacing around text
  chs = {
    m = { l = '[', r = ']' },
    c = { l = '+', r = '+' },
  },
}

function M.setup(conf)
  conf = conf or {}
  for k, v in pairs(conf) do
    config[k] = v
  end
end

-- Get proper comment prefix/suffix for the current buffer
local function get_comment_str()
  local cs = vim.bo.commentstring or '# %s'
  local pre = cs:match '^(.*)%%s' or ''
  local suf = cs:match '%%s(.*)$' or ''
  return pre, suf
end

-- Insert a single block comment
function M.comment(opts)
  local text = vim.fn.input 'text'
  if text == '' then
    text = config.default_text
  end

  local pre, suf = get_comment_str()
  local chs = config.chs
  local total_width = math.max(config.min_width, #text + config.padding * 2)

  -- Center the text
  local space = total_width - #text - #pre - #suf - 4
  local left = math.floor(space / 2)
  local right = space - left
  local middle = ('%s%s%s  %s  %s%s%s'):format(
    pre,
    chs.m.l,
    (' '):rep(left - #chs.m.l),
    text,
    (' '):rep(right - #chs.m.r),
    chs.m.r,
    suf
  )

  local dashes = total_width - #pre - #suf - #chs.c.l - #chs.c.r
  local line = ('%s')
    :rep(5)
    :format(pre, chs.c.l, ('-'):rep(dashes), chs.c.r, suf)

  -- Insert at current cursor line
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { line, middle, line })
end

-- Comment a table of strings

return M
