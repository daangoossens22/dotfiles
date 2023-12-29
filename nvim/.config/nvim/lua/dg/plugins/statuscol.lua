local M = {
    "luukvbaal/statuscol.nvim",
    lazy = false,
}

function M.config()
    local builtin = require "statuscol.builtin"
    require("statuscol").setup {
        relculright = true,
        clickmod = "c",
        segments = {
            { text = { builtin.foldfunc }, click = "v:lua.ScFa", auto = true },
            {
                sign = { name = { "Diagnostic*" }, maxwidth = 1, colwidth = 1, auto = false },
                click = "v:lua.ScSa",
            },
            {
                sign = { name = { "Dap*" }, maxwidth = 1, colwidth = 1, auto = true },
                click = "v:lua.ScSa",
            },
            { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
            {
                sign = { namespace = { "gitsigns_extmark_signs_" }, maxwidth = 1, colwidth = 1, auto = false },
                click = "v:lua.ScSa",
            },
        },
        ft_ignore = { "lazy", "neotest-summary" },
        bt_ignore = nil,
    }
end

return M
