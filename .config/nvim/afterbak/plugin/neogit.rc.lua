-- local status, neogit = pcall(require, "neogit")
-- if (not status) then return end
--
-- vim.api.nvim_create_user_command(
--   "Git",
--   function()
--       local cwd = vim.fn.expand('%:p:h')
--       neogit.open()
--       vim.cmd(":lcd" .. cwd)
--   end,
--   {nargs = 0}
-- )
--
-- neogit.setup{
--   integrations = {
--     diffview = true
--   }
-- }