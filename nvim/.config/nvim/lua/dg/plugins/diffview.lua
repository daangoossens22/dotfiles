local M = {
    "sindrets/diffview.nvim",
    cmd = {
        "DiffviewOpen",
        "DiffviewFileHistory",
        "DiffviewClose",
        "DiffviewToggleFiles",
        "DiffviewFocusFiles",
        "DiffviewRefresh",
        "DiffviewLog",
    },
}

function M.init()
    MAP("n", "<leader>do", "<cmd>DiffviewOpen<cr>", "[DIFFVIEW] open current changes in a new tab")
    MAP("n", "<leader>dh", "<cmd>DiffviewFileHistory<cr>", "[DIFFVIEW] open file history in a new tab")
end

function M.config()
    local keymap_changes = {
        ["<tab>"] = false,
        ["<s-tab>"] = false,
        {
            "n",
            "<c-l>",
            require("diffview.actions").select_next_entry,
            { desc = "Open the diff for the next file" },
        },
        {
            "n",
            "<c-h>",
            require("diffview.actions").select_prev_entry,
            { desc = "Open the diff for the previous file" },
        },
    }
    require("diffview").setup {
        keymaps = {
            view = keymap_changes,
            file_panel = keymap_changes,
            file_history_panel = keymap_changes,
        },
        file_panel = {
            win_config = {
                win_opts = {
                    cursorlineopt = "both",
                },
            },
        },
        file_history_panel = {
            win_config = {
                win_opts = {
                    cursorlineopt = "both",
                },
            },
        },
        hooks = {
            diff_buf_win_enter = function(bufnr, winid)
                -- require("indent_blankline.commands").disable()
                vim.opt_local.cursorlineopt = { "both" }
                vim.api.nvim_create_autocmd("BufLeave", {
                    buffer = bufnr,
                    command = "set cursorlineopt<",
                    once = true,
                })
            end,
            view_enter = function(view) vim.cmd [[:wincmd 5l]] end,
        },
    }
end

return M
