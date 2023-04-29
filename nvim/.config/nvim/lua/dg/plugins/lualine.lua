local M = {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = {
        "rebelot/kanagawa.nvim",
    },
}

function M.config()
    vim.opt.laststatus = 2
    vim.opt.showmode = false
    vim.g.qf_disable_statusline = 1 -- draw the normal statusline in a quickfix window

    local function lualine_lsp_name()
        -- REF: https://github.com/nvim-lualine/lualine.nvim/blob/master/examples/evil_lualine.lua
        local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
        local clients = vim.lsp.get_active_clients()
        local client_names = {}
        for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                -- always put null-ls at the end of the list displayed
                if client.name == "null-ls" then
                    table.insert(client_names, client.name)
                else
                    table.insert(client_names, 1, client.name)
                end
            end
        end
        local res = table.concat(client_names, "|")

        -- REF: https://github.com/NvChad/ui/blob/3e52dbbfff31912a5d1897fcb15051ad62d0c300/lua/nvchad_ui/statusline/minimal.lua#L97-L121
        local progress_message = vim.lsp.util.get_progress_messages()[1]
        if progress_message then
            local moon = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " }
            local ms = vim.loop.hrtime() / 1000000
            local frame = math.floor(ms / 400) % #moon
            res = (progress_message.percentage or 0) .. "%% " .. moon[frame + 1] .. res
        end
        return res
    end

    local k_colors = require("kanagawa.colors").setup()
    -- local normal_highligth = k_colors.palette.autumnGreen
    local normal_highligth = k_colors.palette.springGreen
    local insert_highligth = k_colors.palette.crystalBlue
    local command_highligth = k_colors.palette.boatYellow2
    local visual_highligth = k_colors.palette.oniViolet
    local replace_highligth = k_colors.palette.autumnRed
    local k_theme = {
        normal = {
            a = { bg = normal_highligth, fg = k_colors.theme.ui.bg_m3 },
            b = { bg = k_colors.palette.winterBlue, fg = normal_highligth },
            c = { bg = k_colors.theme.ui.bg_p1, fg = k_colors.theme.ui.fg },
        },
        insert = {
            a = { bg = insert_highligth, fg = k_colors.theme.ui.bg },
            b = { bg = k_colors.theme.ui.bg, fg = insert_highligth },
        },
        command = {
            a = { bg = command_highligth, fg = k_colors.theme.ui.bg },
            b = { bg = k_colors.theme.ui.bg, fg = command_highligth },
        },
        visual = {
            a = { bg = visual_highligth, fg = k_colors.theme.ui.bg },
            b = { bg = k_colors.theme.ui.bg, fg = visual_highligth },
        },
        replace = {
            a = { bg = replace_highligth, fg = k_colors.theme.ui.bg },
            b = { bg = k_colors.theme.ui.bg, fg = replace_highligth },
        },
        inactive = {
            a = { bg = k_colors.theme.ui.bg_m3, fg = k_colors.theme.ui.fg_dim },
            b = { bg = k_colors.theme.ui.bg_m3, fg = k_colors.theme.ui.fg_dim, gui = "bold" },
            c = { bg = k_colors.theme.ui.bg_m3, fg = k_colors.theme.ui.fg_dim },
        },
    }

    require("lualine").setup {
        options = {
            icons_enabled = false,
            theme = k_theme,
            -- theme = 'kanagawa',
            -- theme = 'gruvbox_dark',

            component_separators = "|",
            section_separators = "",

            disabled_filetypes = {},
            always_divide_middle = true,
            globalstatus = true,
            refresh = {
                statusline = 400,
            },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {
                {
                    require("noice").api.status.mode.get,
                    cond = require("noice").api.status.mode.has,
                },
                { "branch", icons_enabled = true },
                "diff",
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                    always_visible = false,
                    icons_enabled = true,
                },
            },
            lualine_c = {
                -- 'filename',
                { component_separators = "", "filename" },
                { component_separators = "", "%=" },
                {
                    -- icons_enabled = true,
                    -- icon = "LSP:",
                    color = { fg = k_colors.palette.oniViolet },
                    lualine_lsp_name,
                },
            },

            lualine_x = {
                {
                    "b:autoformat",
                    fmt = function(str)
                        if str == "true" then
                            return "AF"
                        else
                            return ""
                        end
                    end,
                },
                {
                    "g:qflistglobal",
                    fmt = function(str)
                        if str == "true" then
                            return "QF" -- quickfix
                        else
                            return "LL" -- location-list
                        end
                    end,
                },
                "encoding",
                "fileformat",
                "filetype",
            },
            lualine_y = {
                "progress",
                { "searchcount" },
                {
                    require("noice").api.status.command.get,
                    cond = require("noice").api.status.command.has,
                },
            },
            lualine_z = { "location" },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },

            lualine_x = { "progress", "location" },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {},
        extensions = {},
    }
end

return M
