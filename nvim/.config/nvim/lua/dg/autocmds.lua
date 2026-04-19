-- keep track of old cursor position
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
        "query",
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
    callback = function() vim.cmd "windo wincmd =" end,
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

vim.api.nvim_create_autocmd("TextYankPost", {
    group = AUGROUP "highlight_yank",
    callback = function() vim.highlight.on_yank() end,
})

vim.cmd [[
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END
]]
