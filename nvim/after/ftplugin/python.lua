-- Python needs extra work for formatting, because it's "special".
vim.keymap.set("n", "<M-I>", function()
  vim.cmd("PyrightOrganizeImports")
  vim.cmd("Black")
end, { buffer = 0 })
