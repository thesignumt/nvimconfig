local lspconfig = require 'lspconfig'
lspconfig.clangd.setup {}
lspconfig.pyright.setup {
  settings = {
    python = {
      pythonPath = 'C:\\Python313\\python.exe',
    },
  },
}
