local SenGen = {}

SenGen.words = {
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

function SenGen:get()
  local sentence = {}
  for _ = 1, math.random(5, 15) do
    table.insert(sentence, self.words[math.random(#self.words)])
  end

  sentence[1] = sentence[1]:gsub('^%l', string.upper)
  return table.concat(sentence, ' ') .. '.'
end

-- Create a Neovim user command
vim.api.nvim_create_user_command('SenGen', function()
  local sentence = SenGen:get()
  vim.fn.setreg('+', sentence)
  print 'sengen yanked'
end, {})
