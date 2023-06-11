local M = {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
}

-- TODO: help: 1) vsplit when only 1 pane horizontally 2) split when multiple splits side by side
function M.config()
    vim.opt.shortmess = "filmnrxoOscF"
    require("noice").setup {
        cmdline = {
            view = "cmdline",
            format = {
                -- filter = { icon = "!" },
                -- lua = false, -- NOTE: no lua hl when having `:=` in the command line
                help = false,
                -- calculator = false,
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
        redirect = {
            view = "split",
            filter = { event = "msg_show" },
        },
        lsp = {
            progress = {
                enabled = false,
            },
            signature = {
                auto_open = {
                    enabled = false,
                    -- trigger = false,
                    -- luasnip = false,
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
        routes = {
            {
                filter = {
                    event = "msg_show",
                    kind = "",
                    cmdline = true,
                    find = "written",
                },
                opts = { skip = true },
            },
        },
    }

    local map_documentation_scroll = function(lhs, scroll_amount)
        MAP({ "i", "s" }, lhs, function()
            if not require("noice.lsp").scroll(scroll_amount) then return lhs end
        end, { silent = true, expr = true, desc = "[NOICE] scroll in documentation window" })
    end
    map_documentation_scroll("<C-d>", 4)
    map_documentation_scroll("<C-u>", -4)
    MAP(
        "c",
        "<S-Enter>",
        function() require("noice").redirect(vim.fn.getcmdline()) end,
        "[NOICE] Redirect Cmdline"
    )
end

return M
