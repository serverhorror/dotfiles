return {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("gruvbox").setup({
            italic = {
                comments = true,
                strings = false,
                folds = true,
                emphasis = true,
                operators = true,
            },
            transparent_mode = true,
        })
    end,
}
