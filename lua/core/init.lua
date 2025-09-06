local modules = {
  'cmds',
  'genor',
  'opts',
  'remaps',
  'snippets',
  'typst',
  'video',
}

-- Require each module
for _, module in ipairs(modules) do
  local ok, err = pcall(require, 'core.' .. module)
  if not ok then
    vim.notify(
      'Error loading core.' .. module .. '\n\n' .. err,
      vim.log.levels.ERROR
    )
  end
end
