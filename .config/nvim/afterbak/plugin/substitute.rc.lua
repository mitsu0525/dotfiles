local status, substitute = pcall(require, "substitute")
if (not status) then return end

vim.keymap.set("n", "s", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
vim.keymap.set("n", "ss", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
vim.keymap.set("n", "S", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
vim.keymap.set("x", "s", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })

substitute.setup({
  on_substitute = function(event)
    require("yanky").init_ring("p", event.register, event.count, event.vmode:match("[vV�]"))
  end,
})
