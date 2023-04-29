local M = {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
}

function M.config()
    -- help/markdown add darker background for code injections
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "markdown" },
        callback = function(ev)
            local ts_parser = ev.match == "help" and "vimdoc" or "markdown"
            local ts_query = [[
(codeblock
  (language)
  (code) @codebg
)
]]
            if ev.match == "markdown" then
                ts_query = [[
(fenced_code_block
  (info_string (language))
  (code_fence_content) @codebg
  )
]]
            end
            local query = vim.treesitter.query.parse(ts_parser, ts_query)
            local parser = vim.treesitter.get_parser(ev.buf, ts_parser, {})
            local tree = parser:parse()[1]
            local root = tree:root()
            local namespace = vim.api.nvim_create_namespace "codeblock"
            for _, node in query:iter_captures(root, ev.buf, 0, -1) do
                local start_row, _, end_row, _ = node:range()

                local lines = vim.api.nvim_buf_get_lines(ev.buf, start_row, end_row, false)
                if #lines ~= 0 then
                    -- skip the empty lines at the start and end of the codeblock
                    -- TODO: check for any whitespace characters (e.g. also \t and spaces)
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
                    local display_ends = {}
                    local display_starts = {}
                    local str_starts = {}
                    for _, line in ipairs(lines) do
                        table.insert(display_ends, vim.fn.strdisplaywidth(line))
                        local start_col = line:find "[^%s]"
                        if start_col then
                            local substr = line:sub(1, start_col - 1)
                            table.insert(display_starts, vim.fn.strdisplaywidth(substr))
                            table.insert(str_starts, vim.api.nvim_strwidth(substr))
                        end
                    end
                    local min_display_col = math.min(unpack(display_starts))
                    local max_display_col = math.max(unpack(display_ends))
                    local min_str_col = math.min(unpack(str_starts))
                    -- NOTE: adds virtual lines to make highlighting beyond the end of the line possible
                    -- NOTE: virtual text uses the column numbers
                    -- NOTE: normal text uses number of characters regardless of column numbers
                    for i, _ in ipairs(lines) do
                        if i >= code_block_start_index and i <= code_block_end_index then
                            local line_width = display_ends[i]
                            if line_width > min_display_col then
                                vim.api.nvim_buf_set_extmark(ev.buf, namespace, start_row + i - 1, min_str_col, {
                                    end_row = start_row + i,
                                    virt_text = {
                                        { string.rep(" ", max_display_col - line_width), "CodeBg" },
                                    },
                                    virt_text_win_col = line_width,
                                    hl_group = "CodeBg",
                                })
                            else
                                -- lines that do not have any text in the codeblock need only the virtual lines
                                vim.api.nvim_buf_set_extmark(ev.buf, namespace, start_row + i - 1, 0, {
                                    virt_text = {
                                        { string.rep(" ", max_display_col - min_display_col), "CodeBg" },
                                    },
                                    virt_text_win_col = min_display_col,
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
                InclineNormal = { bg = colors.palette.crystalBlue, fg = colors.theme.ui.bg_m1 },
                InclineNormalNC = { link = "InclineNormal" },
            }
        end,
    }
    vim.cmd.colorscheme "kanagawa"
end

return M
