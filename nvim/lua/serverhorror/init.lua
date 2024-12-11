vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- vim.g.netrw_liststyle = "3"
-- vim.cmd("let g:netrw_liststyle = 3")

vim.g.wrap = false

vim.g.have_nerd_font = true

-- -- general options
-- vim.opt.statusline = "%<%f %h%m%r%=%-14.(%l,%c%V%)"

vim.opt.number = true
vim.opt.relativenumber = true
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

vim.opt.background = "dark"

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
vim.opt.listchars = { tab = "» ", multispace = "·", leadmultispace = "·", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.scrolloff = 10

vim.opt.hlsearch = true
if vim.fn.has("win32") then
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
else
	vim.opt.shell = "bash"
end
