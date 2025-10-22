return {
    "nvim-lua/plenary.nvim",
    { "nvim-tree/nvim-web-devicons", lazy = false },
    { "alvarosevilla95/luatab.nvim", event = "TabNew", config = true },
    { "tpope/vim-repeat", event = "VeryLazy" },
    { "tpope/vim-sleuth", event = "BufReadPre" },
    { "kylechui/nvim-surround", keys = { "ds", "cs", "ys", { "S", mode = "v" } }, opts = {} },

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
        enabled = false,
    },

    -- -- TODO: plugins to try out
    -- "ThePrimeagen/refactoring.nvim"
    -- "lewis6991/satellite.nvim"
    -- "edluffy/hologram.nvim" or "3rd/image.nvim"
    -- "jbyuki/nabla.nvim",
    -- "jbyuki/venn.nvim" or "vim-scripts/DrawIt"
    -- "smjonas/inc-rename.nvim"
    -- "tommcdo/vim-lion"
    -- "NeogitOrg/neogit" or "kdheepak/lazygit.nvim"
    -- "lewis6991/hover.nvim"
    -- "mfussenegger/nvim-lint"

    -- "stevearc/aerial.nvim" -- use telescope lsp_document_symbols??
    -- "famiu/bufdelete.nvim"
    -- "stevearc/overseer.nvim"
    -- "anuvyklack/hydra.nvim"
    -- "nvimdev/lspsaga.nvim"
    -- "RRethy/vim-illuminate"
    -- "krady21/compiler-explorer.nvim"
    -- "rebelot/heirline.nvim"
    -- "nvim-colortils/colortils.nvim"
    -- "lervag/vimtex"
    -- "benlubas/molten-nvim" or "vim-jukit"
}
