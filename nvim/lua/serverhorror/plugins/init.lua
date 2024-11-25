return {
    -- { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },

    -- "gc" to comment visual regions/lines
    { "numToStr/Comment.nvim", opts = {} },
    { "tpope/vim-sleuth" }, -- Detect tabstop and shiftwidth automatically
    { "Bilal2453/luvit-meta", lazy = true }, -- no idea why this would be needed
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        },
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
