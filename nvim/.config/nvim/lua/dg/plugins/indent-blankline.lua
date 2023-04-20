local M = {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
}

function M.config()
    -- -- TODO: indent_blankline replacement??
    -- vim.opt.listchars = { space = " ", tab = ">~", multispace = "│ " }
    -- vim.opt.listchars = { eol = "↲", tab = "» ", trail = "·", extends = "<", precedes = ">", conceal = "┊", nbsp = "␣" }
    -- vim.opt.list = true

    require("indent_blankline").setup {
        -- enabled = false,

        -- char = '|',
        -- char_list = {'|', '¦', '┆', '┊'},

        -- don't show indent lines for empty lines
        show_trailing_blankline_indent = false,
        show_first_indent_level = false,

        -- -- a bit buggy / try again later
        -- show_current_context = true,
        -- show_current_context_start = true,
        -- -- context_patterns = {'class', 'function', 'method', 'for', 'if'},
        -- -- use_treesitter = true,

        show_foldtext = false,

        -- filetype = {},
        filetype_exclude = { "help", "packer", "man", "tsplayground", "", "norg" },
    }

    MAP("n", "<leader>ri", require("indent_blankline.commands").refresh, "refresh indent guidelines")
    -- NOTE: workaround for guidelines dissapearing when scrolling horizontally
    -- see: https://github.com/lukas-reineke/indent-blankline.nvim/issues/489
    vim.api.nvim_create_autocmd("CursorMoved", {
        command = "IndentBlanklineRefresh",
        group = AUGROUP "indent_blankline_workaround",
    })
end

return M
