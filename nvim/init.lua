-- Config inspired from: https://youtube.com/playlist?list=PLep05UYkc6wTyBe7kPjQFWVXTlhKeQejM
-- Add and configure plugins in the file below (`lua/config/lazy.lua`).
require("config.lazy")


-- [[ Color Scheme ]] --

vim.g.preferred_colorscheme_dark = "material-deep-ocean"
vim.g.preferred_colorscheme_light = "vscode"
vim.opt.background = "dark"
vim.cmd.colorscheme(vim.g.preferred_colorscheme_dark)

vim.api.nvim_create_user_command("ToggleColorSchemeLightDark", function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.opt.background:get() ~= "dark" then
    vim.cmd.colorscheme(vim.g.preferred_colorscheme_dark)
    vim.opt.background = "dark"
  else
    vim.cmd.colorscheme(vim.g.preferred_colorscheme_light)
    vim.opt.background = "light"
  end
end, { desc = "Switch between the preferred light and dark color schemes." })

vim.keymap.set("n", "<leader>c", vim.cmd.ToggleColorSchemeLightDark, { desc = "Toggle ColorScheme", silent = true })


-- [[ General Settings ]] --

vim.opt.expandtab      = true
vim.opt.tabstop        = 4
vim.opt.softtabstop    = 4
vim.opt.shiftwidth     = 4
vim.opt.list           = true
vim.opt.listchars      = { tab = ">-", trail = "#", nbsp = "·" }
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.colorcolumn    = { 80, 100, 110 }
vim.opt.cursorline     = true
vim.opt.signcolumn     = "yes:1"
vim.opt.updatetime     = 300
vim.opt.incsearch      = false
vim.opt.exrc           = true
vim.opt.nrformats      = vim.opt.nrformats + "alpha" -- Allow incrementing/decrementing letters.
vim.opt.showmatch      = true
vim.opt.textwidth      = 80                          -- Override the default textwidth for formatting.
vim.opt.formatoptions:remove({ "t", "c" })           -- Only format with `gq`. Some languages won't obey.


-- [[ General Keymaps ]] --

vim.keymap.set("n", "<Space>", vim.cmd.update, { desc = "Make it easy to spam saving the document" })

-- Navigate easily between windows, from all common modes.
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set({ "i", "t" }, "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set({ "i", "t" }, "<C-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set({ "i", "t" }, "<C-k>", "<C-\\><C-n><C-w>k")
vim.keymap.set({ "i" }, "<C-l>", "<C-\\><C-n><C-w>l") -- Terminals usually clear the screen with Ctrl-L.


-- [[ Plugin-specific ]] --

---@diagnostic disable: missing-fields
vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<M-p>", require("telescope.builtin").find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<M-P>", require("telescope.builtin").commands, { desc = "Telescope find commands" })
vim.keymap.set("n", "<M-K>", require("telescope.builtin").help_tags, { desc = "Telescope find help tags" })
vim.keymap.set("n", "<M-F>", require("telescope.builtin").live_grep, { desc = "Telescope search string" })
vim.keymap.set("n", "<M-f>", require("telescope.builtin").current_buffer_fuzzy_find,
  { desc = "Telescope search in buffer" })

vim.keymap.set("n", "<F4>", function() vim.cmd("VGit toggle_live_gutter") end, { desc = "Toggle Git gutter" })

vim.api.nvim_create_user_command("NeotreeToggle", "Neotree toggle=true source=last", { desc = "Toggle NeoTree" })
vim.keymap.set("n", "<C-n>", vim.cmd.NeotreeToggle, { desc = "Toggle NeoTree" })

-- <C-_> refers to Ctrl-/.
vim.api.nvim_set_keymap("n", "<C-_>", "gcc", { desc = "Toggle comment on line" })
vim.api.nvim_set_keymap("v", "<C-_>", "gc", { desc = "Toggle comments in block" })


-- [[ LSP ]] --

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { desc = "Go to definition of type" })
vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "List references" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "List implementations" })
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<M-I>", vim.lsp.buf.format, { desc = "Format code" })
vim.keymap.set("n", "<F12>", vim.lsp.buf.code_action, { desc = "Take a code action" })


-- [[ Terminal ]] --

vim.api.nvim_create_autocmd("TermOpen", {
  desc = "Default settings for terminals",
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.opt.signcolumn = "auto"
    vim.cmd.startinsert()
  end,
})

vim.api.nvim_create_autocmd("WinEnter", {
  desc = "Enter insert mode in existing terminals by default",
  group = vim.api.nvim_create_augroup("custom-term-autoinsert", { clear = true }),
  callback = function()
    if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "terminal" then
      vim.cmd.startinsert()
    end
  end,
})

vim.api.nvim_create_user_command("TermToggle", function()
  local is_open = vim.g.term_win_id ~= nil and vim.api.nvim_win_is_valid(vim.g.term_win_id)
  if is_open then
    vim.api.nvim_win_hide(vim.g.term_win_id)
    vim.g.term_win_id = nil
    return
  end

  vim.cmd("botright 65 vnew") -- Make the new window large enough.
  vim.g.term_win_id = vim.api.nvim_get_current_win()

  local has_term_buf = vim.g.term_buf_id ~= nil and vim.api.nvim_buf_is_valid(vim.g.term_buf_id)
  if has_term_buf then
    vim.api.nvim_win_set_buf(vim.g.term_win_id, vim.g.term_buf_id)
  else
    vim.cmd.terminal()
    vim.g.term_buf_id = vim.api.nvim_get_current_buf()
  end

  vim.cmd.startinsert()
end, { desc = "Hide/Unhide the global terminal window" })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode easily" })
vim.keymap.set("n", ",", vim.cmd.TermToggle, { desc = "Toggle Terminal", silent = true })
vim.keymap.set("n", "<leader>`", vim.cmd.TermToggle, { desc = "Toggle Terminal", silent = true })
vim.keymap.set("t", "<leader>`", vim.cmd.TermToggle, { desc = "Toggle Terminal", silent = true })
