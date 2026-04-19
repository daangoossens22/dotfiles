local M = {
    "echasnovski/mini.nvim",
}

M.config = function()
    require("mini.ai").setup()
    require("mini.splitjoin").setup()
    -- require("mini.operators").setup()
    -- require("mini.pairs").setup()
    require("mini.statusline").setup()
    -- configured likes 'tpope/vim-surround'; see `:h MiniSurround-vim-surround-config`
    require("mini.surround").setup {
        mappings = {
            add = "ys",
            delete = "ds",
            find = "",
            find_left = "",
            highlight = "",
            replace = "cs",
            update_n_lines = "",
            suffix_last = "",
            suffix_next = "",
        },
        search_method = "cover_or_next",
    }
    vim.keymap.del("x", "ys")
    vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
    vim.keymap.set("n", "yss", "ys_", { remap = true })
end

return M
