return {
    -- "norcalli/nvim-colorizer.lua",
    -- pin = true,
    -- TODO: check out https://github.com/echasnovski/mini.hipatterns
    "NvChad/nvim-colorizer.lua",
    keys = {
        { "<leader>ct", "<cmd>ColorizerToggle<cr>", desc = "toggle showing color codes visually" },
    },
    config = function()
        require("colorizer").setup {
            filetypes = {},
            user_default_options = {
                mode = "background",
                css = true,
            },
            buftypes = {},
        }
    end,
}
