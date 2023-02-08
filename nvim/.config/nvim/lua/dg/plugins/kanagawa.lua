---@diagnostic disable: undefined-field
local M = {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
}

function M.config()
    vim.opt.background = "dark"

    local dc = require("kanagawa.colors").setup {}
    require("kanagawa").setup {
        globalStatus = true,
        dimInactive = true,
        overrides = {
            Todo = { fg = dc.bg_light0, bg = dc.diag.hint, bold = true },
            ["@text.warning"] = { fg = dc.bg_light0, bg = dc.diag.hint, bold = true },
            ["@text.note"] = { fg = dc.bg_light0, bg = dc.diag.info, bold = true },
            ["@text.danger"] = { fg = dc.bg_light0, bg = dc.sakuraPink, bold = true },
            WinSeparator = {
                fg = dc.bg_light0,
            },
        },
    }
    vim.cmd.colorscheme "kanagawa"
end

return M
