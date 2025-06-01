return {
    -- LSP Installer
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {},
        config = function()
            require("mason").setup()
        end,
    },
    -- Mason extension to enable setting up LSP servers with lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "neovim/nvim-lspconfig", -- The main lspconfig plugin
            "williamboman/mason.nvim",
        },
        opts = {
            -- Automatically install servers that are not already installed.
            automatic_installation = true,
            -- This handler will be called for each installed server
            -- It tries to load the default setup for each server
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({})
                end,
                -- You can add custom handlers for specific servers if needed
                -- ["lua_ls"] = function()
                --   require("lspconfig").lua_ls.setup {
                --     settings = {
                --       Lua = {
                --         runtime = {
                --           version = "LuaJIT",
                --         },
                --         workspace = {
                --           checkThirdParty = false,
                --         },
                --         completion = {
                --           callSnippet = "Replace",
                --         },
                --       },
                --     },
                --   }
                -- end,
            },
        },
        config = function(_, opts)
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "gopls",
                    "lua_ls",
                }
            })
        end,
    },
    {
        "neovim/nvim-lspconfig", -- The main lspconfig plugin
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.gopls.setup({})
            lspconfig.lua_ls.setup({})
        end,
    },
}
