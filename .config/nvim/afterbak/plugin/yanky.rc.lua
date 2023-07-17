local status, yanky = pcall(require, "yanky")
if (not status) then return end

vim.keymap.set({'n', 'x'}, 'y', '<Plug>(YankyYank)',        { silent = true })
vim.keymap.set({'n', 'x'}, 'p', '<Plug>(YankyPutAfter)',    { silent = true })
vim.keymap.set({'n', 'x'}, 'P', '<Plug>(YankyPutBefore)',   { silent = true })
vim.keymap.set({'n', 'x'}, 'gp', '<Plug>(YankyGPutAfter)',  { silent = true })
vim.keymap.set({'n', 'x'}, 'gP', '<Plug>(YankyGPutBefore)', { silent = true })

vim.keymap.set('n', '<C-p>', function()
  if yanky.can_cycle() then
    return '<Plug>(YankyCycleForward)'
  else
    return '<C-p>'
  end 
end, { silent = true, expr = true })

vim.keymap.set('n', '<C-n>', function()
  if yanky.can_cycle() then
    return '<Plug>(YankyCycleBackward)'
  else
    return '<C-n>'
  end 
end, { silent = true, expr = true })

local utils = require('yanky.utils')
local mapping = require('yanky.telescope.mapping')

yanky.setup({
   ring = {
    history_length = 1000,
    storage = "sqlite",
    sync_with_numbered_registers = false,
  },
  highlight = {
    on_yank = true,
    timer = 300,
  },
  picker = {
    telescope = {
      mappings = {
        default = mapping.set_register('p'),
        i = {
          ["<C-p>"] = mapping.put('p'),
          ["<C-k>"] = mapping.put('P'),
          ["<C-x>"] = mapping.delete(),
          ["<C-r>"] = mapping.set_register(utils.get_default_register()),
        },
        n = {
          p = mapping.put('p'),
          P = mapping.put('P'),
          d = mapping.delete(),
          r = mapping.set_register(utils.get_default_register())
        },
      }
    }
  }
})
