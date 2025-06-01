return {
    {
        "nvim-telescope/telescope-ui-select.nvim"
    },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        -- or                          , branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            "nvim-telescope/telescope-ui-select.nvim"
        },
        opts = {
            ["ui-select"] = {
                require("telescope.themes").get_dropdown({
                })
            }
        },
        config = function(_, opts)
            require("telescope").setup({})
            require("telescope").load_extension("ui-select")

            local builtin = require("telescope.builtin")

            -- Keymap for listing files in the current directory
            vim.keymap.set("n", "<leader>o", builtin.find_files, {})
            -- Keymap for listing git files in the current directory
            vim.keymap.set("n", "<leader>g", builtin.git_files, {})
            -- Keymap for grepping in files, in the current directory
            vim.keymap.set("n", "<leader>/", function()
                local word = vim.fn.expand("<cWORD>")
                builtin.grep_string({search = word })
            end, {})
        end,
    }
}
