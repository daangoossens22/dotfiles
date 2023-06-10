local M = {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = {
        "rebelot/kanagawa.nvim",
        "folke/noice.nvim",
    },
}

function M.config()
    vim.opt.laststatus = 2
    vim.opt.showmode = false
    vim.g.qf_disable_statusline = 1 -- draw the normal statusline in a quickfix window

    LSP_PERCENTAGES = {}
    vim.api.nvim_create_autocmd("LspProgress", {
        callback = function(event)
            local lsp_id = event.data.client_id
            LSP_PERCENTAGES[lsp_id] = event.data.result.value.percentage or LSP_PERCENTAGES[lsp_id]
            if event.data.result.value.kind == "end" then LSP_PERCENTAGES[lsp_id] = nil end
            require("lualine").refresh()
        end,
        group = AUGROUP "lualine_lsp_progress_refresh",
    })
    local function lualine_lsp_name()
        -- REF: https://github.com/NvChad/ui/blob/3e52dbbfff31912a5d1897fcb15051ad62d0c300/lua/nvchad_ui/statusline/minimal.lua#L97-L121
        local moons = { "🌑 ", "🌘 ", "🌗 ", "🌖 ", "🌕 ", "🌔 ", "🌓 ", "🌒 " }
        local ms = vim.loop.hrtime() / 1000000
        local frame = math.floor(ms / 400) % #moons
        local moon = moons[frame + 1]

        local bufnr = vim.fn.bufnr()
        local clients = vim.lsp.get_active_clients { bufnr = bufnr }
        local client_names = {}
        for _, client in ipairs(clients) do
            local client_str = client.name
            local percentage = LSP_PERCENTAGES[client.id]
            if percentage then client_str = moon .. percentage .. "%% " .. client_str end

            if client.name == "null-ls" then
                table.insert(client_names, client_str)
            else
                table.insert(client_names, 1, client_str)
            end
        end
        local res = table.concat(client_names, "|")

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
                -- { component_separators = "", "filename" },
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
