local M = {
    "nvim-lualine/lualine.nvim",
    lazy = false,
}

function M.config()
    vim.opt.laststatus = 2
    vim.opt.showmode = false
    vim.g.qf_disable_statusline = 1 -- draw the normal statusline in a quickfix window

    -- inspired from: https://github.com/nvim-lualine/lualine.nvim/blob/master/examples/evil_lualine.lua
    local function lualine_lsp_name()
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
        return table.concat(client_names, "|")
    end

    local kanagawa_colors = require("kanagawa.colors").setup()
    local custom_kanagawa = require "lualine.themes.kanagawa"
    -- normal => green ; insert => blue
    custom_kanagawa.insert.a.bg = custom_kanagawa.normal.a.bg
    custom_kanagawa.insert.b.fg = custom_kanagawa.normal.b.fg
    custom_kanagawa.normal.a.bg = "#6ea459"
    custom_kanagawa.normal.b.fg = "#6ea459"

    require("lualine").setup {
        options = {
            icons_enabled = false,
            theme = custom_kanagawa,
            -- theme = 'kanagawa',
            -- theme = 'gruvbox_dark',

            component_separators = "|",
            section_separators = "",

            disabled_filetypes = {},
            always_divide_middle = true,
            globalstatus = true,
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {
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
                    icons_enabled = true,
                    icon = "LSP:",
                    color = { fg = kanagawa_colors.oniViolet },
                    lualine_lsp_name,
                },
            },

            lualine_x = {
                {
                    "g:qflistglobal",
                    fmt = function(str)
                        if str == "true" then
                            return "QF global"
                        else
                            return "QF local"
                        end
                    end,
                },
                "encoding",
                "fileformat",
                "filetype",
            },
            lualine_y = { "progress" },
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
