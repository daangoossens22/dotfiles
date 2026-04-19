local M = {
    "lewis6991/gitsigns.nvim",
}

function M.config()
    require("gitsigns").setup {
        on_attach = function(bufnr)
            local gitsigns = require "gitsigns"

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                if opts.desc then opts.desc = "[GIT] " .. opts.desc end
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "]c", function()
                if vim.wo.diff then
                    vim.cmd.normal { "]c", bang = true }
                else
                    gitsigns.nav_hunk "next"
                end
            end)

            map("n", "[c", function()
                if vim.wo.diff then
                    vim.cmd.normal { "[c", bang = true }
                else
                    gitsigns.nav_hunk "prev"
                end
            end)

            -- Actions
            map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "stage/unstage hunk" })
            map(
                "v",
                "<leader>hs",
                function() gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" } end,
                { desc = "stage/unstage hunk" }
            )
            map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "reset hunk" })
            map(
                "v",
                "<leader>hr",
                function() gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" } end,
                { desc = "reset hunk" }
            )

            map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "stage buffer" })
            map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "reset buffer" })
            map("n", "<leader>hp", gitsigns.preview_hunk_inline, { desc = "preview hunk" })
            map("n", "<leader>hU", gitsigns.reset_buffer_index, { desc = "unstage whole buffer" })
            map("n", "<leader>hb", function() gitsigns.blame_line { full = true } end, { desc = "blame current line" })
            map("n", "<leader>htb", gitsigns.toggle_current_line_blame, { desc = "toggle blame current line" })
            map("n", "<leader>hd", gitsigns.diffthis, { desc = "diff current file without staged changes" })
            map("n", "<leader>hD", function() gitsigns.diffthis "~" end, { desc = "diff current file" })
            map("n", "<leader>hq", function() gitsigns.setqflist "all" end, { desc = "add project hunks to qflist" })

            -- Toggles
            map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
            map("n", "<leader>tw", gitsigns.toggle_word_diff)

            -- Text object
            map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "inner hunk text object" })
        end,
        attach_to_untracked = true,
        current_line_blame_opts = {
            delay = 250,
        },
    }
end

return M
