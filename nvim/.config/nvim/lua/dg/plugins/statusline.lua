local M = {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "rebelot/kanagawa.nvim",
        -- "folke/noice.nvim",
        {
            "SmiteshP/nvim-navic",
            opts = {
                lsp = {
                    auto_attach = true,
                    preference = { "verible" },
                },
                highlight = true,
                click = true,
            },
        },
    },
}

function M.config()
    vim.opt.laststatus = 2
    vim.opt.showmode = false

    LSP_PERCENTAGES = {}
    vim.api.nvim_create_autocmd("LspProgress", {
        callback = function(event)
            local lsp_id = event.data.client_id
            LSP_PERCENTAGES[lsp_id] = event.data.params.value.percentage or LSP_PERCENTAGES[lsp_id]
            if event.data.params.value.kind == "end" then LSP_PERCENTAGES[lsp_id] = nil end
            require("lualine").refresh { place = { "statusline" } }
        end,
        group = AUGROUP "lualine_lsp_progress_refresh",
    })
    local function lualine_lsp_name()
        -- REF: https://github.com/NvChad/ui/blob/3e52dbbfff31912a5d1897fcb15051ad62d0c300/lua/nvchad_ui/statusline/minimal.lua#L97-L121
        local moons = { "🌑 ", "🌘 ", "🌗 ", "🌖 ", "🌕 ", "🌔 ", "🌓 ", "🌒 " }
        local ms = vim.uv.hrtime() / 1000000
        local frame = math.floor(ms / 400) % #moons
        local moon = moons[frame + 1]

        local bufnr = vim.fn.bufnr()
        local clients = vim.lsp.get_clients { bufnr = bufnr }
        local client_names = {}
        for _, client in ipairs(clients) do
            local client_str = client.name
            local percentage = LSP_PERCENTAGES[client.id]
            if percentage then client_str = moon .. percentage .. "%% " .. client_str end

            table.insert(client_names, client_str)
        end
        local res = table.concat(client_names, "|")

        return res
    end

    local k_colors = require("kanagawa.colors").setup { theme = "wave" }

    require("lualine").setup {
        options = {
            icons_enabled = false,
            -- theme = k_theme,
            theme = "kanagawa",
            -- theme = "gruvbox_dark",

            component_separators = "|",
            section_separators = "",

            disabled_filetypes = {},
            always_divide_middle = true,
            globalstatus = false,
            -- refresh = {
            --     statusline = 400,
            -- },
        },
        sections = {
            lualine_a = { { "mode", fmt = function(str) return str:sub(1, 1) end } },
            lualine_b = {
                { "branch", icons_enabled = true },
                "diff",
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                    always_visible = false,
                    icons_enabled = true,
                    on_click = function() vim.diagnostic.setloclist() end,
                },
            },
            lualine_c = {
                -- NOTE: used instead of "filename" since it also shows the directory in an oil buffer
                { "%f%m", component_separators = "|" },
                { component_separators = "", "%=" },
                {
                    color = { fg = k_colors.palette.oniViolet },
                    on_click = function() vim.cmd [[:LspInfo]] end,
                    lualine_lsp_name,
                },
            },

            lualine_x = {
                {
                    function()
                        if AUTOFORMAT_LANGUAGES[vim.bo.filetype] then
                            return "AF"
                        else
                            return "MF"
                        end
                    end,
                    on_click = function()
                        AUTOFORMAT_LANGUAGES[vim.bo.filetype] = not AUTOFORMAT_LANGUAGES[vim.bo.filetype]
                    end,
                },
                { "encoding" },
                { "fileformat", icons_enabled = true },
                { "filetype", icons_enabled = true },
            },
            lualine_y = {
                "progress",
                { "searchcount" },
                -- {
                --     -- TODO: show keys as you type (instead of only showing when full command is formed)
                --     require("noice").api.status.command.get,
                --     cond = require("noice").api.status.command.has,
                -- },
            },
            lualine_z = { "location" },
        },
        winbar = {
            lualine_c = {
                {
                    function() return require("nvim-navic").get_location() end,
                    cond = function() return require("nvim-navic").is_available() end,
                },
            },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "%f%m" },

            lualine_x = { "progress", "location" },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {},
        extensions = {},
    }
end

return M
