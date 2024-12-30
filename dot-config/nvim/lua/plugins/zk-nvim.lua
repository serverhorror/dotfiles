return {
	"zk-org/zk-nvim",
	config = function()
		require("zk").setup({
			-- can be "telescope", "fzf", "fzf_lua", "minipick", or "select" (`vim.ui.select`)
			-- it's recommended to use "telescope", "fzf", "fzf_lua", or "minipick"
			picker = "telescope",

			lsp = {
				-- `config` is passed to `vim.lsp.start_client(config)`
				config = {
					cmd = { "zk", "lsp" },
					name = "zk",
					-- on_attach = ...
					-- etc, see `:h vim.lsp.start_client()`
				},

				-- automatically attach buffers in a zk notebook that match the given filetypes
				auto_attach = {
					enabled = true,
					filetypes = { "markdown" },
				},
			},
		})

		local which_key = require("which-key")
		which_key.add({
			{ "<leader>z", group = "[Z]ettelkasten" },
			{
				"<leader>zn",
				function()
					require("zk.commands").get("ZkNew")({
						-- get the title from an input prompt
						title = vim.fn.input("Title: "),
					})
				end,
				desc = "Create a new Zettelkasten note",
			},
			{
				mode = { "v" },
				{
					"<leader>zn",
					"<Cmd>'<,'>ZkNewFromContentSelection<CR>",
					desc = "Create a new Zettelkasten note from visual selection",
				},
			},
			-- { "<leader>ze", "Edit Zk Note" },
			-- { "<leader>zr", "Open Zk Note" },
			-- { "<leader>zl", "List Zk Notes" },
			-- { "<leader>zg", "Grep Zk Notes" },
			-- { "<leader>zq", "Quit Zk Note" },
		})

		-- local commands = require("zk.commands")
		-- commands.get("ZkNew")({})
	end,
}
