local highlight_groups = require("vscode_dark_plus.highlight_groups")

local M = {}

--- @class Config
--- @field v2 boolean
--- @field cursorline boolean
--- @field transparent_background boolean
M.config = {
    v2 = false,
    cursorline = false,
    transparent_background = false,
}

--- @overload fun(config: Config)
function M.setup(config)
    M.config = vim.tbl_deep_extend("force", M.config, config or {})
end

function M.load()
    vim.cmd("hi clear")

    vim.o.background = "dark"

    if vim.fn.exists("sintax_on") then
        vim.cmd("syntax reset")
    end

    vim.o.termguicolors = true
    vim.g.colors_name = "vscode_dark_plus"

    highlight_groups.set(M.config)
end

return M
