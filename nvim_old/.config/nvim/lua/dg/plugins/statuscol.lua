local M = {
    "luukvbaal/statuscol.nvim",
    lazy = false,
}

-- TODO: see if you can also show the vim marks: https://github.com/luukvbaal/statuscol.nvim/issues/116
function M.config()
    local builtin = require "statuscol.builtin"
    require("statuscol").setup {
        relculright = true,
        clickmod = "c",
        segments = {
            {
                text = { builtin.foldfunc },
                colwidth = 1,
                click = "v:lua.ScFa",
                auto = true,
            },
            {
                -- sign = { name = { "Diagnostic*" }, maxwidth = 1, colwidth = 1, auto = false },
                sign = {
                    namespace = { "diagnostic" },
                    maxwidth = 1,
                    colwidth = 1,
                    foldclosed = true,
                    auto = false,
                },
                click = "v:lua.ScSa",
            },
            {
                sign = {
                    name = { "Dap*" },
                    maxwidth = 1,
                    colwidth = 1,
                    foldclosed = true,
                    auto = true,
                },
                click = "v:lua.ScSa",
            },
            { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
            {
                sign = {
                    namespace = { "gitsigns_signs_" },
                    maxwidth = 1,
                    colwidth = 1,
                    foldclosed = true,
                    auto = false,
                },
                click = "v:lua.ScSa",
            },
        },
        ft_ignore = { "lazy", "neotest-summary" },
        bt_ignore = nil,
    }
end

return M
