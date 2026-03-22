return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    -- Moving textobjects INSIDE dependencies is the key fix here
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      -- Now that we are inside the config function,
      -- nvim-treesitter is guaranteed to be on the runtime path.
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "bash", "c", "diff", "go", "html", "lua", "luadoc", "markdown",
          "markdown_inline", "python", "query", "vim", "vimdoc",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
            },
          },
        },
      })
    end,
  },
}
