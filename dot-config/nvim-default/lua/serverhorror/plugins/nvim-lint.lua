return {
	"mfussenegger/nvim-lint",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
	},
	config = function()
		local linters = {
			shellcheck = {
				filetypes = { "sh", "bash" },
			},
			shfmt = {
				filetypes = { "sh", "bash" },
			},
		}
		require("mason-lspconfig").setup({
			ensure_installed = linters,
		})
		require("lint").linters_by_ft = {
			lua = { "luacheck" },
			sh = { "shfmt", "shellcheck" },
			-- vim = { "vint" },
		}
		require("lint").default_severity = {
			["error"] = vim.diagnostic.severity.ERROR,
			["warning"] = vim.diagnostic.severity.WARN,
			["information"] = vim.diagnostic.severity.INFO,
			["hint"] = vim.diagnostic.severity.HINT,
		}
	end,
}
