-- disable wrapping
vim.opt.wrap = false

-- Make line numbers default
vim.opt.number = true
vim.opt.colorcolumn = {"78", "80", "100"}

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Enable break indent
vim.opt.breakindent = true


-- default border
vim.o.winborder = "rounded"
-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '»␣»', trail = '·', nbsp = '␣' }

-- space follows: , 1 tab follows:  , 2 tabs follow:        end

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

