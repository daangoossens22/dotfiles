return {
    -- "nvim-lua/plenary.nvim",
    { "nvim-tree/nvim-web-devicons" },
    { "alvarosevilla95/luatab.nvim", event = "TabNew", config = true },
    -- { "tpope/vim-repeat" },
    { "tpope/vim-sleuth" },
    {
        "lervag/vimtex",
        lazy = false,
        -- tag = "v2.15",
        init = function()
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_syntax_enabled = 0
            vim.g.vimtex_syntax_conceal_disable = 1
            vim.g.vimtex_quickfix_open_on_warning = 0
        end,
    },
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                systemverilog = { "slang" },
            }
            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function() require("lint").try_lint() end,
            })
        end,
    },
}
