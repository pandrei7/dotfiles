-- Python needs extra work for formatting, because it's "special".
vim.keymap.set("n", "<M-I>", function()
  vim.cmd("Black")
  vim.cmd("Isort")
end, { buffer = 0 })
