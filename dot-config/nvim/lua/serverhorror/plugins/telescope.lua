return {
    {
        "nvim-telescope/telescope-ui-select.nvim"
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
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
            local telescope = require('telescope')
            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')
            telescope.load_extension("ui-select")

            telescope.setup({})

            local builtin = require("telescope.builtin")

            -- vim help files
            vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })

            -- Keymap for listing files in the current directory
            vim.keymap.set("n", "<leader>o", builtin.find_files, { desc = "[O]pen File" })
            vim.keymap.set("n", "<leader>so", function()
                builtin.find_files({
                    opts = { hidden = true, },
                })
            end, { desc = "[S]earch files to [O]pen" })
            -- Keymap for listing git files in the current directory
            vim.keymap.set("n", "<leader>sg", builtin.git_files, { desc = "[S]earch [G]it tracked files" })
            -- Keymap for grepping in files, in the current directory
            vim.keymap.set("n", "<leader>s/", function()
                local word = vim.fn.expand("<cWORD>")
                echo(word)
                builtin.grep_string({ search = word })
            end, { desc = "[S]earch [G]it tracked files" })

            -- Slightly advanced example of overriding default behavior and theme
            vim.keymap.set('n', '<leader>/', function()
                -- You can pass additional configuration to Telescope to change the theme, layout, etc.
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, { desc = '[/] Fuzzily search in current buffer' })
        end,
    }
}
