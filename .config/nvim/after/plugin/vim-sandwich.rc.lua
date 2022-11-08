vim.g.sandwich_no_default_key_mappings             = 1
vim.g.textobj_functioncall_no_default_key_mappings = 1

vim.keymap.set({'n', 'x'}, 'sa',  '<Plug>(sandwich-add)',          {silent = true})
vim.keymap.set({'n', 'x'}, 'sd',  '<Plug>(sandwich-delete)',       {silent = true})
vim.keymap.set({'n', 'x'}, 'sdb', '<Plug>(sandwich-delete-auto)',  {silent = true})
vim.keymap.set({'n', 'x'}, 'sr',  '<Plug>(sandwich-replace)',      {silent = true})
vim.keymap.set({'n', 'x'}, 'srb', '<Plug>(sandwich-replace-auto)', {silent = true})

vim.keymap.set({'o', 'x'}, 'ib', '<Plug>(textobj-sandwich-auto-i)', {silent = true})
vim.keymap.set({'o', 'x'}, 'ab', '<Plug>(textobj-sandwich-auto-a)', {silent = true})

vim.g['sandwich#recipes'] = vim.deepcopy(vim.g['sandwich#default_recipes'])
