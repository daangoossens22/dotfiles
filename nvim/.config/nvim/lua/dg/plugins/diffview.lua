local M = {
    "sindrets/diffview.nvim",
    cmd = {
        "DiffviewOpen",
        "DiffviewFileHistory",
    },
    keys = {
        { "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "[DIFFVIEW] open current changes in a new tab" },
        { "<leader>dh", "<cmd>DiffviewFileHistory<cr>", desc = "[DIFFVIEW] open file history in a new tab" },
    },
}

local keymap_changes = {
    ["<tab>"] = false,
    ["<s-tab>"] = false,
    ["]d"] = function() require("diffview.actions").select_next_entry() end,
    ["[d"] = function() require("diffview.actions").select_prev_entry() end,
}
local diffviewopts = { win_config = { win_opts = { cursorlineopt = "both" } } }

---@class DiffviewConfig
M.opts = {
    keymaps = {
        view = keymap_changes,
        file_panel = vim.tbl_extend("force", keymap_changes, {
            ["<cr>"] = function() require("diffview.config").actions.focus_entry() end,
        }),
        file_history_panel = keymap_changes,
    },
    file_panel = diffviewopts,
    file_history_panel = diffviewopts,
    -- view = {
    --     default = {
    --         disable_diagnostics = true,
    --     },
    -- },
}

return M
