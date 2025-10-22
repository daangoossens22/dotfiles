return {
    "karb94/neoscroll.nvim",
    keys = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
    enabled = false,
    config = function()
        -- REF: https://github.com/karb94/neoscroll.nvim/issues/80
        require("neoscroll").setup {
            -- performance_mode = true,
            pre_hook = function()
                vim.opt.eventignore:append {
                    "WinScrolled",
                    "CursorMoved",
                }
            end,
            post_hook = function()
                vim.opt.eventignore:remove {
                    "WinScrolled",
                    "CursorMoved",
                }
            end,
        }
    end,
}
