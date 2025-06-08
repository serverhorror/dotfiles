return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function(_, opts)
            local harpoon = require("harpoon")

            -- REQUIRED
            harpoon:setup({})
            -- REQUIRED


            local conf = require("telescope.config").values
            local function toggle_telescope(harpoon_files)
                local file_paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(file_paths, item.value)
                end

                require("telescope.pickers").new({}, {
                    prompt_title = "Harpoon",
                    finder = require("telescope.finders").new_table({
                        results = file_paths,
                    }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                }):find()
            end


            local harpoon_extensions = require("harpoon.extensions")
            harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

            vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
            vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
            -- vim.keymap.set("n", "<leader>hh", function()
            --     toggle_telescope(harpoon:list())
            -- end, {desc = "Open harpoon window" })


            -- Toggle previous & next buffers stored within Harpoon list
            vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end)
            vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end)
        end,
    }
}
