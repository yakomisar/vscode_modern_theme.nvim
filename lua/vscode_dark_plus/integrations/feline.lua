local colors = require("vscode_dark_plus.palette")
local config = require("vscode_dark_plus").config

local M = {}

M.palette = function()
    return {
        bg = config.v2 and colors.bg_02 or "#007acc",
        fg = config.v2 and colors.fg_08 or "#ffffff",
        vi_mode_bg = config.v2 and "#0078d4" or colors.green_01,
    }
end

local diagnostic = {
    error = colors.red_04,
    warn = colors.yellow_03,
    info = colors.blue_07,
    hint = colors.green_05,
}

local git = {
    added = colors.green_03,
    deleted = colors.red_04,
    changed = colors.blue_03,
}

M.components = function()
    local components = { active = {}, inactive = {} }

    local vi_mode_utils = require("feline.providers.vi_mode")

    components.active[1] = {
        {
            provider = " ",
            hl = { bg = "vi_mode_bg" },
        },
        {
            provider = "vi_mode",
            hl = function()
                return {
                    name = vi_mode_utils.get_mode_highlight_name(),
                    style = "NONE",
                    bg = "vi_mode_bg",
                }
            end,
            icon = "",
        },
        {
            provider = " ",
            hl = { bg = "vi_mode_bg" },
        },
        {
            provider = "git_diff_added",
            icon = " +",
            hl = { fg = config.v2 and git.added or "fg" },
        },
        {
            provider = "git_diff_changed",
            icon = " ~",
            hl = { fg = config.v2 and git.changed or "fg" },
        },
        {
            provider = "git_diff_removed",
            icon = " -",
            hl = { fg = config.v2 and git.deleted or "fg" },
        },
        {
            provider = "git_branch",
            icon = { str = " " },
            left_sep = " ",
        },
        {
            provider = function()
                if #vim.lsp.buf_get_clients(0) == 0 then
                    return "LSP inactive"
                end

                local clients = {}

                for _, client in pairs(vim.lsp.buf_get_clients(0)) do
                    clients[#clients + 1] = client.name
                end

                return table.concat(clients, " "), " "
            end,
            left_sep = " ",
        },
        {
            provider = function()
                local lsp = vim.lsp.util.get_progress_messages()[1]

                if lsp then
                    local msg = lsp.message or ""
                    local percentage = lsp.percentage or 0
                    local title = lsp.title or ""

                    local spinners = { "", "", "" }

                    local success_icon = { "", "", "" }

                    local ms = vim.loop.hrtime() / 1000000
                    local frame = math.floor(ms / 120) % #spinners

                    if percentage >= 70 then
                        return string.format(" %%<%s %s %s (%s%%%%) ", success_icon[frame + 1], title, msg, percentage)
                    end

                    return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
                end

                return ""
            end,
        },
        {
            provider = "diagnostic_errors",
            icon = "  ",
            hl = { fg = diagnostic.error },
        },
        {
            provider = "diagnostic_warnings",
            icon = "  ",
            hl = { fg = diagnostic.warn },
        },
        {
            provider = "diagnostic_hints",
            icon = "  ",
            hl = { fg = diagnostic.hint },
        },
        {
            provider = "diagnostic_info",
            icon = "  ",
            hl = { fg = diagnostic.info },
        },
    }
    components.active[2] = {
        {
            provider = "line_percentage",
            left_sep = " ",
            right_sep = " ",
        },
        {
            provider = function()
                local total_lines = vim.fn.line("$")
                local total_visible_lines = vim.fn.line("w$")

                if total_lines <= total_visible_lines then
                    return ""
                end

                return total_lines .. " lines"
            end,
            left_sep = " ",
            right_sep = " ",
        },
        {
            provider = { name = "file_info", opts = { file_readonly_icon = " ", file_modified_icon = "" } },
            left_sep = " ",
            right_sep = " ",
        },
        {
            provider = function()
                local word = vim.bo.expandtab and "Spaces" or "Tab Size"
                return word .. ": " .. ((vim.bo.tabstop ~= "" and vim.bo.tabstop) or vim.o.tabstop)
            end,
            left_sep = " ",
            right_sep = " ",
        },
        {
            provider = function()
                return ((vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc)
            end,
            left_sep = " ",
            right_sep = " ",
        },
        {
            provider = function()
                return ((vim.bo.fileformat ~= "" and vim.bo.fileformat) or vim.o.fileformat)
            end,
            left_sep = " ",
            right_sep = " ",
        },
        {
            provider = { name = "file_type", opts = { case = "lowercase" } },
            left_sep = " ",
            right_sep = " ",
        },
    }
    components.inactive[1] = {
        {
            provider = " ",
            hl = { bg = colors.green_01 },
        },
        {
            provider = "file_type",
            hl = { bg = colors.green_01 },
        },
        {
            provider = " ",
            hl = { bg = colors.green_01 },
            right_sep = { " " },
        },
    }
    components.inactive[2] = {}

    return components
end

return M
