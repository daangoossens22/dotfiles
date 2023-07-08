vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        if ev.match ~= "norg" then
            vim.opt_local.formatoptions = table.concat {
                -- "t", -- auto-wrap
                "c", -- auto-wrap comments
                "r", -- add comment leader after hitting <Enter> in a comment
                "o", -- add comment leader after hitting 'o' or 'O' (undo with i<C-u>)
                -- "/", -- ???
                "q", -- allow formatting of comments using 'gq'
                -- "w", -- line that ends in a non-wite space character denotes the end of the paragraph
                -- "a", -- auto-format paragraphs (+c flag -> only do this in comments)
                "n", -- indents text when wrapping when using a numbered list (autoindent needs to be set)
                -- "2", -- copy indent of second line in paragraph (autoindent needs to be set)
                -- "v", -- vi-compatible auto-wrap in insert mode
                -- "b", -- ???
                "l", -- long line is not wrapped in insert mode when the line was already longer than textwidth
                -- "m", -- breaks multibyte characters above 255 (usefull for asian characters)
                -- "M", -- when joining lines don't insert space before or after multibyte character
                -- "B", -- when joining lines don't insert space between multibyte character
                -- "1", -- don't break line before one-letter words (do it before that)
                -- "]", -- no line can be longer than textwidth (only works for utf-8)
                "j", -- remove comment leader when joining lines
                -- "p", -- don't break lines at period followed by a space but one before that
            }

            if ev.match == "gitcommit" then vim.opt_local.formatoptions:append { "t" } end
        end
    end,
    group = AUGROUP "formatoptions",
})

-- -- persistant folds and cursor position when opening and closing nvim
-- -- REF: https://vim.fandom.com/wiki/Make_views_automatic
-- -- NOTE: doesn't play nice with nvim-ufo
-- vim.opt.viewoptions = {
--     "folds",
--     -- "cursor",
--     -- "curdir",
-- }
-- local augroup_persistant_cursor_folds = AUGROUP "persistant_cursor_folds"
-- -- NOTE: ZZ doesn't seem to save when folds and cursor when file hasn't changed
-- vim.api.nvim_create_autocmd({ "BufWritePost", "BufLeave", "WinLeave" }, {
--     pattern = "?*",
--     command = "mkview",
--     group = augroup_persistant_cursor_folds,
-- })
-- vim.api.nvim_create_autocmd("BufWinEnter", {
--     pattern = "?*",
--     command = "silent! loadview",
--     group = augroup_persistant_cursor_folds,
-- })

-- don't have to save file for keep track of old cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
    group = AUGROUP "last_loc",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
    end,
})

-- REF: https://github.com/LazyVim/LazyVim/blob/ef21bea975df97694f7491dcd199d9d116227235/lua/lazyvim/config/autocmds.lua#L42
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "help",
        "notify",
        "qf",
        "tsplayground",
        "checkhealth",
        "neotest-summary",
        "neotest-output-panel",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
    group = AUGROUP "close_with_q",
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = AUGROUP "resize_splits",
    callback = function() vim.cmd "tabdo wincmd =" end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = AUGROUP "checktime",
    command = "checktime",
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = AUGROUP "auto_create_dir",
    callback = function(event)
        if event.match:match "^%w%w+://" then return end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})
