local function sengen()
  local words = {
    'lorem',
    'ipsum',
    'dolor',
    'sit',
    'amet',
    'consectetur',
    'adipiscing',
    'elit',
    'sed',
    'do',
    'eiusmod',
    'tempor',
    'incididunt',
    'ut',
    'labore',
    'et',
    'dolore',
    'magna',
    'aliqua',
    'enim',
    'ad',
    'minim',
    'veniam',
    'quis',
    'nostrud',
    'exercitation',
    'ullamco',
    'laboris',
    'nisi',
    'ut',
    'aliquip',
    'ex',
    'ea',
    'commodo',
    'consequat',
  }
  local sentence = {}
  for _ = 1, math.random(5, 15) do
    table.insert(sentence, words[math.random(#words)])
  end
  sentence[1] = sentence[1]:gsub('^%l', string.upper) -- Capitalize the first word
  return table.concat(sentence, ' ') .. '.'
end

vim.api.nvim_create_user_command('SenGen', function()
  local sentence = sengen()
  vim.fn.setreg('+', sentence)
  print 'sengen yanked'
end, {})
