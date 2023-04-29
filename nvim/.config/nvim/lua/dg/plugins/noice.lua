local M = {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
}

function M.config()
    require("noice").setup {
        cmdline = {
            view = "cmdline",
            format = {
                -- filter = { icon = "!" },
                -- lua = false, -- NOTE: no lua hl when having `:=` in the command line
                help = false,
                calculator = false,
            },
        },
        messages = {
            -- view = "notify",
            -- view_error = "mini",
            -- view_warn = "mini",
            view_search = false,
        },
        popupmenu = {
            enabled = false,
            backend = "cmp",
        },
        lsp = {
            progress = {
                enabled = false,
            },
            signature = {
                -- enabled = false,
                auto_open = {
                    enabled = false,
                },
            },
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        presets = {
            -- long_message_to_split = true,
        },
    }
    MAP("c", "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, "Redirect Cmdline")
end

return M
