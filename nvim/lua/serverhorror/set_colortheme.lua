local M = {}
local set_colortheme = function(color)
    color = color or "default"
    vim.cmd.colorscheme(color)

    -- bad idea
    -- vim.api.nvim_set_hl(0, "Comment", { fg = math.random(-180, 180) })

    -- Set the background to none for the following groups
    -- This is useful for floating windows, popups, etc.
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    vim.api.nvim_set_hl(0, "CopilotSuggestion", {
        bg = "none",
        fg = "#555555",
        ctermfg = 8,
        force = true,
    })
    -- -- make sure the current line is slightly different
    -- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#292c32" })
end
M.set_colortheme = set_colortheme
return M.set_colortheme
