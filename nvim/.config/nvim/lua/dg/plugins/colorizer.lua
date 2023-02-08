return {
    -- "norcalli/nvim-colorizer.lua",
    -- pin = true,
    "NvChad/nvim-colorizer.lua",
    keys = {
        { "<leader>ct", "<cmd>ColorizerToggle<cr>", desc = "toggle showing color codes visually" },
    },
    config = function()
        require("colorizer").setup({ nil }, {
            mode = "background",
            css = true,
        })
    end,
}
