-- Predefined Jobs
vim.api.nvim_create_user_command('Credo', function()
  vim.cmd('!mix credo')
end, {})
