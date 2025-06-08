return {
    {
        'stevearc/conform.nvim',
        opts = {},
        config = function()
            require("conform").setup({
                -- lua
                lua = { "stylua" },
                -- Conform will run multiple formatters sequentially
                python = { "isort", "black" },
                -- Go
                go = { "gofmt", lsp_format = "fallback" },
            })
        end,
    }
}
