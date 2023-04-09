return {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
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

    -- -- TODO: plugins to try out
    -- use "stevearc/aerial.nvim" -- use telescope lsp_document_symbols??
    -- use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'}
    -- use "famiu/bufdelete.nvim"
    -- use "ThePrimeagen/refactoring.nvim"
    -- use "folke/noice.nvim"
}
