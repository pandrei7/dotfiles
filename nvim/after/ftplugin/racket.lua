-- Don't mess with keybinds ffs!
vim.keymap.del("n", "K", { buffer = 0 })
vim.keymap.del("x", "K", { buffer = 0 })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
