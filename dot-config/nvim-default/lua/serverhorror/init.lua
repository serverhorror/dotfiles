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

-- begin global settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.wrap = false
vim.g.have_nerd_font = true
-- end global settings

vim.opt.background = "dark"
vim.opt.number = true
vim.opt.relativenumber = true
-- begin mode based relative line numbers
-- This makes the relative line numbers toggle when entering a window or buffer
vim.api.nvim_create_augroup("numbertoggle", { clear = true })
vim.api.nvim_create_autocmd(
	{ "BufEnter", "WinEnter", "FocusGained", "InsertLeave" },
	{ group = "numbertoggle", pattern = "*", command = "set relativenumber" }
)
vim.api.nvim_create_autocmd(
	{ "BufLeave", "WinLeave", "FocusLost", "InsertEnter" },
	{ group = "numbertoggle", pattern = "*", command = "set norelativenumber" }
)
-- end mode based relative line numbers

-- -- Sync clipboard between OS and Neovim.
-- --  Schedule the setting after `UiEnter` because it can increase startup-time.
-- --  Remove this option if you want your OS clipboard to remain independent.
-- --  See `:help 'clipboard'`
-- vim.schedule(function()
--     vim.opt.clipboard = "unnamedplus"
-- end)
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.keywordprg = "tldr"
-- Use the colors the terminal already has
vim.opt.termguicolors = false

-- tabstop, shiftwidth
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes:3"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.splitright = false
vim.opt.splitbelow = false

vim.opt.list = true
vim.opt.listchars = { tab = "»", multispace = "·", leadmultispace = "·", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.scrolloff = 10

vim.opt.hlsearch = true
local function is_wsl()
	return vim.fn.systemlist("uname -r")[1] == "microsoft-standard"
end
if not (vim.fn.has("win32")) then
	print("Not Windows")
	vim.opt.shell = "bash"
else
	print("Windows")
	vim.opt.shell = "pwsh"
	local powershell_options = {
		shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
		shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8; $PSDefaultParameterValues['Out-File:Encoding']='UTF8';Remove-Alias -Force -ErrorAction SilentlyContinue tee;",
		shellredir = '2>&1 > | %%{ "$_" } | Out-File %s; exit $LastExitCode',
		shellpipe = '2>&1 > | %%{ "$_" } | tee %s; exit $LastExitCode',
		shellquote = "",
		shellxquote = "",
	}

	for option, value in pairs(powershell_options) do
		vim.opt[option] = value
	end
end
-- Plugins & Color Themes
require("serverhorror.lazy")
