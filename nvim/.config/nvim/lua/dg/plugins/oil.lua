local M = {
    "stevearc/oil.nvim",
    keys = {
        { "-", function() require("oil").open() end, desc = "[OIL] open parent directory" },
        {
            "<leader>-",
            function() require("oil").open_float() end,
            desc = "[OIL] open parent directory in float window",
        },
    },
}

function M.config()
    require("oil").setup {
        default_file_explorer = true,
        delete_to_trash = true,
        view_options = {
            show_hidden = true,
        },
        keymaps = {
            ["q"] = "actions.close",
            ["<C-q>"] = "actions.send_to_qflist",
        },
    }
end

return M
