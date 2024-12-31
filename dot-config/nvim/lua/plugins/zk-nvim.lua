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

		local zk = require("zk")
		local commands = require("zk.commands")

		local function make_edit_fn(defaults, picker_options)
			return function(options)
				options = vim.tbl_extend("force", defaults, options or {})
				zk.edit(options, picker_options)
			end
		end

		commands.add("ZkOrphans", make_edit_fn({ orphan = true }, { title = "Zk Orphans" }))
		commands.add("ZkRecents", make_edit_fn({ createdAfter = "2 weeks ago" }, { title = "Zk Recents" }))

		local get_title = function()
			return vim.fn.input("Title: ")
		end

		local which_key = require("which-key")
		which_key.add({
			-- normal mode mappings
			{
				mode = { "n" },
				{
					{ "<leader>z", group = "[Z]ettelkasten" },
					{
						"<leader>zn",
						function()
							commands.get("ZkNew")({
								-- get the title from an input prompt
								title = get_title(),
							})
						end,
						desc = "Create a new Zettelkasten note",
					},
					{
						"<leader>zl",
						make_edit_fn({ sort = { "modified" } }, { title = "Zk Notes" }),
						desc = "[L]ist Notes",
					},
					-- { "<leader>zg", commands.get("ZkGrep"), desc = "[G]rep Notes" },
					{ "<leader>zO", commands.get("ZkOrphans"), desc = "Edit [O]rphans" },
					{ "<leader>zr", commands.get("ZkRecents"), desc = "Edit [R]ecents" },
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
