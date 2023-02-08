local M = {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
}

function M.config()
    require("gitsigns").setup {
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                if opts.desc then opts.desc = "[GIT] " .. opts.desc end
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "]c", function()
                if vim.wo.diff then return "]c" end
                vim.schedule(function() gs.next_hunk() end)
                return "<Ignore>"
            end, { expr = true, desc = "next hunk" })

            map("n", "[c", function()
                if vim.wo.diff then return "[c" end
                vim.schedule(function() gs.prev_hunk() end)
                return "<Ignore>"
            end, { expr = true, desc = "prev hunk" })

            -- Actions
            map(
                { "n", "v" },
                "<leader>hs",
                ":Gitsigns stage_hunk<cr>",
                { silent = true, desc = "stage hunk" }
            )
            map(
                { "n", "v" },
                "<leader>hr",
                ":Gitsigns reset_hunk<cr>",
                { silent = true, desc = "reset hunk" }
            )
            map("n", "<leader>hS", gs.stage_buffer, { desc = "stage buffer" })
            map("n", "<leader>hR", gs.reset_buffer, { desc = "reset buffer" })
            map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "undo last staged hunk" })
            map("n", "<leader>hU", gs.reset_buffer_index, { desc = "unstage whole buffer" })
            map("n", "<leader>hp", gs.preview_hunk, { desc = "preview hunk" })
            map("n", "<leader>hb", WRAP(gs.blame_line, { full = true }), { desc = "blame current line" })
            map("n", "<leader>htb", gs.toggle_current_line_blame, { desc = "toggle blame current line" })
            map("n", "<leader>hd", gs.diffthis, { desc = "diff current file" })
            map("n", "<leader>hq", WRAP(gs.setqflist, "all"), { desc = "add project hunks to qflist" })
            -- TODO: what is the difference
            map("n", "<leader>hD", WRAP(gs.diffthis, "~"), { desc = "diff current file" })
            map("n", "<leader>htd", gs.toggle_deleted, { desc = "toggle deleted" })
            map("n", "<leader>hd", gs.toggle_current_line_blame, { desc = "toggle current line blame" })

            -- Text object
            map(
                { "o", "x" },
                "ih",
                ":<C-U>Gitsigns select_hunk<CR>",
                { silent = true, desc = "inner hunk text object" }
            )
        end,
        watch_gitdir = {
            interval = 1000,
            follow_files = true,
        },
        attach_to_untracked = true,
        -- Toggle with `:Gitsigns toggle_current_line_blame` (remap with `overlay option set)
        current_line_blame = false,
        current_line_blame_opts = {
            virt_text = true,
            -- virt_text_pos = 'eol',
            virt_text_pos = "overlay", -- so that it doesn't go off the screen
            delay = 250,
            ignore_whitespace = false,
        },
        current_line_blame_formatter_opts = {
            relative_time = false,
        },
        -- sign_priority = 11,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000,
        preview_config = {
            -- Options passed to nvim_open_win
            border = "single",
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1,
        },
        yadm = {
            enable = false,
        },
    }
end

return M
