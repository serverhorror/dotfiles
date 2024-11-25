-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<C-/>", "gcc", { desc = "Comment selection" })
vim.keymap.set("n", "gcc", "<C-/>", { desc = "Comment selection" })
-- the greatest remap ever (Primeagen)
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

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
local serverhorror = require("serverhorror")

-- Plugins & Color Themes
require("serverhorror.lazy")

-- Theme
local set_colortheme = require("serverhorror.set_colortheme")
set_colortheme("gruvbox")

-- use 'marko-cerovac/material.nvim'
