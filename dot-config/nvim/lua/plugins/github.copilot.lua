return { -- BEGIN GitHub Copilot
	"github/copilot.vim",
	config = function()
		-- -- make sure ~/src is in the workspace root and
		-- -- set the workspace folder to the root of the project
		-- vim.g.copilot_workspace_folders = { vim.fn.getcwd(), "~/src" }
		-- -- Disable default key mappings
		-- vim.g.copilot_no_tab_map = true
		-- vim.g.copilot_assume_mapped = true
		-- vim.g.copilot_tab_fallback = ""

		-- -- Set keybindings for Copilot
		-- vim.api.nvim_set_keymap("i", "<C-y>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
		-- vim.api.nvim_set_keymap("i", "<C-n>", "copilot#Next()", { silent = true, expr = true })
		-- vim.api.nvim_set_keymap("i", "<C-p>", "copilot#Previous()", { silent = true, expr = true })
	end,
} -- END GitHub Copilot
