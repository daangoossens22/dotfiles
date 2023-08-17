local M = {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
}

function M.config()
    -- REF: https://github.com/folke/tokyonight.nvim
    ---@param foreground string foreground color
    ---@param background string background color
    ---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
    local function blend(foreground, background, alpha)
        alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha

        local function hexToRgb(c)
            c = string.lower(c)
            return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
        end

        local bg = hexToRgb(background)
        local fg = hexToRgb(foreground)

        local blendChannel = function(i)
            local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
            return math.floor(math.min(math.max(0, ret), 255) + 0.5)
        end

        return string.format("#%02x%02x%02x", blendChannel(1), blendChannel(2), blendChannel(3))
    end

    require("kanagawa").setup {
        compile = false,
        dimInactive = false,
        ---@type fun(colors: { theme: ThemeColors, palette: PaletteColors}): table<string, table>
        overrides = function(colors)
            local blend_ratio = 0.1
            return {
                -- make todo/warning/note/danger highlight more noticable by highlighting the bg
                Todo = { fg = colors.theme.ui.bg_m1, bg = colors.theme.diag.hint, bold = true },
                ["@text.warning"] = {
                    fg = colors.theme.ui.bg_m1,
                    bg = colors.theme.diag.warning,
                    bold = true,
                },
                ["@text.note"] = { fg = colors.theme.ui.bg_m1, bg = colors.theme.diag.info, bold = true },
                ["@text.danger"] = { fg = colors.theme.ui.bg_m1, bg = colors.palette.sakuraPink, bold = true },
                -- ["@lsp.type.comment"] = {}, -- don't have semantic highlighting for comments (overwriting my todo highlighting)

                -- copy tokyonight by having virtual diagnostic text be glowy
                DiagnosticVirtualTextError = {
                    fg = colors.theme.diag.error,
                    bg = blend(colors.theme.diag.error, colors.theme.ui.bg, blend_ratio),
                },
                DiagnosticVirtualTextWarn = {
                    fg = colors.theme.diag.warning,
                    bg = blend(colors.theme.diag.warning, colors.theme.ui.bg, blend_ratio),
                },
                DiagnosticVirtualTextInfo = {
                    fg = colors.theme.diag.info,
                    bg = blend(colors.theme.diag.info, colors.theme.ui.bg, blend_ratio),
                },
                DiagnosticVirtualTextHint = {
                    fg = colors.theme.diag.hint,
                    bg = blend(colors.theme.diag.hint, colors.theme.ui.bg, blend_ratio),
                },

                WinSeparator = {
                    fg = colors.theme.ui.bg_p1,
                },
                LspInlayHint = { link = "LspReferenceText" },
                CodeBlock = { bg = colors.theme.ui.bg_m3 },
                DapSigns = { bg = colors.theme.ui.bg_gutter },
                InclineNormal = { fg = colors.theme.ui.bg_m1, bg = colors.palette.crystalBlue },
                InclineNormalNC = { fg = colors.palette.crystalBlue, bg = colors.theme.ui.bg_m1 },
                ["@neorg.todo_items.on_hold"] = { fg = colors.theme.diag.info, bold = true },
                ["@neorg.todo_items.urgent"] = { fg = colors.palette.sakuraPink, bold = true },
                ["@neorg.todo_items.urgent.content"] = { bold = true },
                Folded = { bg = blend(colors.palette.oniViolet, colors.theme.ui.bg, 0.2), bold = true },
            }
        end,
    }
    vim.cmd.colorscheme "kanagawa"
end

return M
