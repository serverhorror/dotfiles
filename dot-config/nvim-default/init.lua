-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- vim.keymap.set("n", "<C-/>", "gcc", { desc = "Comment selection" })
vim.keymap.set("n", "gcc", "<C-/>", { desc = "Comment selection" })
-- the greatest remap ever (Primeagen)
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- <leader>n to set nohlsearch, the second parameter is the function (reference) to call
vim.keymap.set("n", "<leader>n", function()
	vim.cmd("nohlsearch")
end, { desc = "Clear search highlights" })
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- My Config
require("serverhorror")

-- Plugins & Color Themes
require("serverhorror.lazy")

-- local _border = "double"
--
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
--     border = _border,
-- })
--
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
--     border = _border,
-- })
--
-- vim.diagnostic.config({
--     float = { border = _border },
-- })
