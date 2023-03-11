local M = {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
}

function M.config()
    -- helptags add darker background for code snippets
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "help",
        callback = function(ev)
            local query = vim.treesitter.query.parse_query(
                "help",
                [[
(codeblock
  (language)
  (code) @codebg
)
]]
            )
            local parser = vim.treesitter.get_parser(ev.buf, "help", {})
            local tree = parser:parse()[1]
            local root = tree:root()
            for _, node in query:iter_captures(root, ev.buf, 0, -1) do
                local start_row, _, end_row, _ = node:range()
                local namespace = vim.api.nvim_create_namespace "codeblock"

                -- highlight codeblock with the "CodeBg" hl group which just covers the width of the codeblock
                local lines = vim.api.nvim_buf_get_lines(ev.buf, start_row, end_row, false)
                local line_ends = {}
                local line_starts = {}
                for _, line in ipairs(lines) do
                    table.insert(line_ends, vim.api.nvim_strwidth(line))
                    local start_col = line:find "[^%s]"
                    if start_col then table.insert(line_starts, start_col - 1) end
                end
                local min_col = math.min(unpack(line_starts))
                local max_col = math.max(unpack(line_ends))
                -- NOTE: adds virtual lines to make highlighting beyond the end of the line possible
                for i, _ in ipairs(lines) do
                    local line_width = line_ends[i]
                    vim.api.nvim_buf_set_extmark(ev.buf, namespace, start_row + i - 1, min_col, {
                        end_row = start_row + i,
                        virt_text = { { string.rep(" ", max_col - line_width), "CodeBg" } },
                        virt_text_win_col = line_width,
                        hl_group = "CodeBg",
                    })
                end

                -- -- highlight the whole lines of the codeblock with the "CodeBg" hl group
                -- vim.api.nvim_buf_set_extmark(ev.buf, namespace, start_row, 0, {
                --     end_row = end_row,
                --     hl_group = "CodeBg",
                --     hl_eol = true,
                -- })
            end
        end,
        group = vim.api.nvim_create_augroup("dg_help_bg", { clear = true }),
    })

    require("kanagawa").setup {
        compile = true, -- set to false to not need to run ':KanagawaCompile' after each config change
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
                ["@include"] = { fg = colors.palette.oniViolet },
                ["@function.macro"] = { fg = colors.palette.surimiOrange },
                CodeBg = { bg = colors.theme.ui.bg_m3, bold = true },
            }
        end,
    }
    vim.cmd.colorscheme "kanagawa"
end

return M
