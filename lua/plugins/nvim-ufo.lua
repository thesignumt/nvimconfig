return {
  'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  config = function()
    require('ufo').setup {
      provider_selector = function(_, _, _)
        return { 'treesitter', 'indent' }
      end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, _) -- _: truncate
        local newVirtText = {}
        local suffix = (' ⯈ %d lines'):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if curWidth + chunkWidth <= targetWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = vim.fn.strcharpart(chunkText, 0, targetWidth - curWidth)
            table.insert(newVirtText, { chunkText, chunk[2] })
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end,
    }

    local nmap = require('utils.map').nmap
    nmap('zR', require('ufo').openAllFolds)
    nmap('zM', require('ufo').closeAllFolds)
    nmap('zr', require('ufo').openFoldsExceptKinds)
    nmap('zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
  end,
}
