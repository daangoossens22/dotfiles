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
            local query = vim.treesitter.query.parse(
                "vimdoc",
                [[
(codeblock
  (language)
  (code) @codebg
)
]]
            )
            local parser = vim.treesitter.get_parser(ev.buf, "vimdoc", {})
            local tree = parser:parse()[1]
            local root = tree:root()
            local namespace = vim.api.nvim_create_namespace "codeblock"
            for _, node in query:iter_captures(root, ev.buf, 0, -1) do
                local start_row, _, end_row, _ = node:range()

                local lines = vim.api.nvim_buf_get_lines(ev.buf, start_row, end_row, false)
                if #lines ~= 0 then
                    -- skip the empty lines at the start and end of the codeblock
                    local code_block_start_index = 0
                    local code_block_end_index = #lines
                    for i, line in ipairs(lines) do
                        if line ~= "" then
                            code_block_start_index = i
                            break
                        end
                    end
                    for i = #lines, 1, -1 do
                        if lines[i] ~= "" then
                            code_block_end_index = i
                            break
                        end
                    end

                    -- highlight codeblock with the "CodeBg" hl group which just covers the width of the codeblock
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
                        if i >= code_block_start_index and i <= code_block_end_index then
                            local line_width = line_ends[i]
                            if line_width > min_col then
                                vim.api.nvim_buf_set_extmark(ev.buf, namespace, start_row + i - 1, min_col, {
                                    end_row = start_row + i,
                                    virt_text = { { string.rep(" ", max_col - line_width), "CodeBg" } },
                                    virt_text_win_col = line_width,
                                    hl_group = "CodeBg",
                                    -- strict = false,
                                })
                            else
                                -- lines that do not have any text in the codeblock need only the virtual lines
                                vim.api.nvim_buf_set_extmark(ev.buf, namespace, start_row + i - 1, 0, {
                                    virt_text = { { string.rep(" ", max_col - min_col), "CodeBg" } },
                                    virt_text_win_col = min_col,
                                })
                            end
                        end
                    end

                    -- -- highlight the whole lines of the codeblock with the "CodeBg" hl group
                    -- vim.api.nvim_buf_set_extmark(ev.buf, namespace, start_row + code_block_start_index - 1, 0, {
                    --     end_row = end_row - #lines + code_block_end_index,
                    --     hl_group = "CodeBg",
                    --     hl_eol = true,
                    -- })
                end
            end
        end,
        group = vim.api.nvim_create_augroup("dg_help_bg", { clear = true }),
    })

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
                CodeBg = { bg = colors.theme.ui.bg_m3, bold = true },
                DapSigns = { bg = colors.theme.ui.bg_gutter },
            }
        end,
    }
    vim.cmd.colorscheme "kanagawa"
end

return M
