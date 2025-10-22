local M = {
    "stevearc/oil.nvim",
    event = "VeryLazy",
}

function M.config()
    require("oil").setup {
        default_file_explorer = true,
        delete_to_trash = false,
        view_options = {
            show_hidden = true,
        },
        keymaps = {
            ["q"] = "actions.close",
        },
    }

    MAP("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    MAP("n", "<leader>-", require("oil").toggle_float, { desc = "Open parent directory in float window" })
    -- TODO: if an oil window show full path in lualine
end

return M
