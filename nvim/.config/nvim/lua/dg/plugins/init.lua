return {
    "nvim-lua/plenary.nvim",
    { "nvim-tree/nvim-web-devicons", lazy = false },
    { "alvarosevilla95/luatab.nvim", event = "TabNew", config = true },
    { "tpope/vim-repeat", event = "VeryLazy" },
    { "tpope/vim-sleuth", event = "BufReadPre" },
    { "tpope/vim-surround", keys = { "ds", "cs", "ys", { "S", mode = "v" } } },
    {
        "karb94/neoscroll.nvim",
        keys = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        config = function()
            -- REF: https://github.com/karb94/neoscroll.nvim/issues/80
            require("neoscroll").setup {
                pre_hook = function()
                    ---@diagnostic disable-next-line: param-type-mismatch
                    vim.opt.eventignore:append {
                        "WinScrolled",
                        "CursorMoved",
                    }
                end,
                post_hook = function()
                    ---@diagnostic disable-next-line: param-type-mismatch
                    vim.opt.eventignore:remove {
                        "WinScrolled",
                        "CursorMoved",
                    }
                end,
            }
        end,
    },

    {
        "b0o/incline.nvim",
        lazy = false,
        config = function()
            require("incline").setup {
                hide = {
                    cursorline = true,
                    -- focused_win = true,
                },
                ignore = {
                    unlisted_buffers = false,
                    buftypes = {},
                    -- wintypes = {},
                },
                window = { margin = { vertical = 0 } },
                render = function(props)
                    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
                    -- local icon, color = require("nvim-web-devicons").get_icon_color(filename)
                    -- { icon, guifg = color }
                    local winnr = vim.fn.getwininfo(props.win)[1].winnr
                    return {
                        { winnr },
                        { " " },
                        { filename },
                    }
                end,
            }
        end,
    },

    {
        "daangoossens22/query-highlighter.nvim",
        dev = true,
        opts = {
            skip_empty_lines_start_and_end = true,
        },
        config = true,
        ft = { "help", "markdown" },
    },

    -- -- TODO: plugins to try out
    -- "stevearc/aerial.nvim" -- use telescope lsp_document_symbols??
    -- "famiu/bufdelete.nvim"
    -- "ThePrimeagen/refactoring.nvim"
}
