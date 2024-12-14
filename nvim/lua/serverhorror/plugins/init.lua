return {
	-- { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },

	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },

	{ "tpope/vim-sleuth" }, -- Detect tabstop and shiftwidth automatically
	{ "Bilal2453/luvit-meta", lazy = true }, -- no idea why this would be needed
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		-- opts = {
		-- 	signs = {
		-- 		add = { text = "+" },
		-- 		change = { text = "~" },
		-- 		delete = { text = "_" },
		-- 		topdelete = { text = "‾" },
		-- 		changedelete = { text = "~" },
		-- 	},
		-- },
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gitsigns.nav_hunk("next")
						end
					end)

					map("n", "[c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end, { desc = "Navigate to previous hunk" })

					-- Actions
					map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
					map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
					map("v", "<leader>hs", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Stage hunk" })
					map("v", "<leader>hr", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Reset hunk" })
					map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
					map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
					map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
					map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
					map("n", "<leader>hb", function()
						gitsigns.blame_line({ full = true })
					end, { desc = "Blame line" })
					map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle blame line" })
					map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff this" })
					map("n", "<leader>hD", function()
						gitsigns.diffthis("~")
					end, { desc = "Diff this (cached)" })
					map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Toggle deleted" })

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
				end,
			})
		end,
	},

	-- BEGIN GitHub Copilot
	{
		"github/copilot.vim",
		config = function()
			-- make sure ~/src is in the workspace root and
			-- set the workspace folder to the root of the project
			vim.g.copilot_workspace_folders = { vim.fn.getcwd(), "~/src" }
		end,
	},
	-- END GitHub Copilot
	{ "nvim-treesitter/playground", dependencies = { "nvim-treesitter/nvim-treesitter" } },
}
