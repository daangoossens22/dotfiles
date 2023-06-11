local M = {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
}

function M.config()
    require("kanagawa").setup {
        compile = false,
        dimInactive = true,
        ---@type fun(colors: { theme: ThemeColors, palette: PaletteColors}): table<string, table>
        overrides = function(colors)
            return {
                Todo = { fg = colors.theme.ui.bg_m1, bg = colors.theme.diag.hint, bold = true },
                ["@text.warning"] = {
                    fg = colors.theme.ui.bg_m1,
                    bg = colors.theme.diag.warning,
                    bold = true,
                },
                ["@text.note"] = { fg = colors.theme.ui.bg_m1, bg = colors.theme.diag.info, bold = true },
                ["@text.danger"] = { fg = colors.theme.ui.bg_m1, bg = colors.palette.sakuraPink, bold = true },
                WinSeparator = {
                    fg = colors.theme.ui.bg_p1,
                },
                ["@lsp.type.comment"] = {}, -- don't have semantic highlighting for comments (overwriting my todo highlighting)
                CodeBlock = { bg = colors.theme.ui.bg_m3, bold = true },
                DapSigns = { bg = colors.theme.ui.bg_gutter },
                InclineNormal = { bg = colors.palette.crystalBlue, fg = colors.theme.ui.bg_m1 },
                InclineNormalNC = { link = "InclineNormal" },
                ["@neorg.todo_items.on_hold"] = { fg = colors.theme.diag.info, bold = true },
                ["@neorg.todo_items.urgent"] = { fg = colors.palette.sakuraPink, bold = true },
                ["@neorg.todo_items.urgent.content"] = { bold = true },
                LspInlayHint = { link = "LspReferenceText" },
            }
        end,
    }
    vim.cmd.colorscheme "kanagawa"
end

return M
