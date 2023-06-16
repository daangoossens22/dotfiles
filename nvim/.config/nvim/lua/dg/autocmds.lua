vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        -- if ev.match ~= "gitcommit" then vim.opt_local.formatoptions:remove { "o", "t" } end
        vim.opt_local.formatoptions = {
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
    end,
    group = AUGROUP "formatoptions",
})

-- persistant folds and cursor position when opening and closing nvim
-- REF: https://vim.fandom.com/wiki/Make_views_automatic
vim.opt.viewoptions = {
    "folds",
    "cursor",
    -- "curdir",
}
local augroup_persistant_cursor_folds = AUGROUP "persistant_cursor_folds"
vim.api.nvim_create_autocmd({ "BufWritePost", "BufLeave", "WinLeave" }, {
    pattern = "?*",
    command = "mkview",
    group = augroup_persistant_cursor_folds,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "?*",
    command = "silent! loadview",
    group = augroup_persistant_cursor_folds,
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
