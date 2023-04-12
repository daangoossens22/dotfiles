local M = {
    "luukvbaal/statuscol.nvim",
    lazy = false,
}

function M.config()
    local builtin = require "statuscol.builtin"
    require("statuscol").setup {
        relculright = true,
        segments = {
            { text = { builtin.foldfunc }, click = "v:lua.ScFa", auto = true },
            {
                sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true },
                click = "v:lua.ScSa",
            },
            {
                sign = { name = { "Diagnostic" }, maxwidth = 1, colwidth = 1, auto = true },
                click = "v:lua.ScSa",
            },
            {
                sign = { name = { "Dap*" }, maxwidth = 1, colwidth = 1, auto = true },
                click = "v:lua.ScSa",
            },
            { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
            {
                sign = { name = { "GitSigns*" }, maxwidth = 1, colwidth = 1 },
                click = "v:lua.ScSa",
            },
        },
    }
end

return M
