local M = {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPre",
}

function M.config()
    -- -- TODO: indent_blankline replacement??
    -- vim.opt.listchars = { space = " ", tab = ">~", multispace = "│ " }
    -- vim.opt.listchars = { eol = "↲", tab = "» ", trail = "·", extends = "<", precedes = ">", conceal = "┊", nbsp = "␣" }
    -- vim.opt.list = true

    require("ibl").setup {
        scope = {
            enabled = false,
        },
        exclude = {
            filetypes = { "help", "man", "tsplayground", "", "norg", "notify", "lazy" },
        },
    }

    local hooks = require "ibl.hooks"
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
end

return M
