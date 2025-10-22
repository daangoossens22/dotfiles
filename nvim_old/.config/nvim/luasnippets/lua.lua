local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require "luasnip.util.events"
local ai = require "luasnip.nodes.absolute_indexer"
local extras = require "luasnip.extras"
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require "luasnip.extras.expand_conditions"
local postfix = require("luasnip.extras.postfix").postfix
local types = require "luasnip.util.types"
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet

local require_var = function(args, _)
    local text = args[1][1] or ""
    local split = vim.split(text, ".", { plain = true })

    local options = {}
    for len = 0, #split - 1 do
        local option = table.concat(vim.list_slice(split, #split - len, #split), "_")
        P(option)
        table.insert(options, i(nil, option))
    end

    return sn(nil, {
        c(1, options),
    })
end

return {
    s(
        "lf",
        fmta(
            [[
    local <> = function(<>)
        <>
    end]],
            { i(1), i(2), i(3) }
        )
    ),
    s(
        "mf",
        fmta(
            [[
    <>.<> = function(<>)
        <>
    end]],
            { i(1, "M"), i(2), i(3), i(4) }
        )
    ),

    s("lreq", fmta([[local <> = require("<>")]], { d(2, require_var, { 1 }), i(1) })),

    s(
        "ok",
        fmta(
            [[
            if not pcall(require, "<>") then
                return
            end
            ]],
            { i(1) }
        )
    ),

    s("su", fmta([[require("<>").setup({ <> })]], { i(1), i(2) })),

    s(
        "pc",
        fmta(
            [[
local M = {
    "<>",<>
}

function M.init()
    <>
end

function M.config()
    <>
end

return M
    ]],
            { i(1), i(2), i(3), i(0) }
        )
    ),

    s(
        "luasnip",
        t {
            'local ls = require "luasnip"',
            "local s = ls.snippet",
            "local sn = ls.snippet_node",
            "local isn = ls.indent_snippet_node",
            "local t = ls.text_node",
            "local i = ls.insert_node",
            "local f = ls.function_node",
            "local c = ls.choice_node",
            "local d = ls.dynamic_node",
            "local r = ls.restore_node",
            'local events = require "luasnip.util.events"',
            'local ai = require "luasnip.nodes.absolute_indexer"',
            'local extras = require "luasnip.extras"',
            "local l = extras.lambda",
            "local rep = extras.rep",
            "local p = extras.partial",
            "local m = extras.match",
            "local n = extras.nonempty",
            "local dl = extras.dynamic_lambda",
            'local fmt = require("luasnip.extras.fmt").fmt',
            'local fmta = require("luasnip.extras.fmt").fmta',
            'local conds = require "luasnip.extras.expand_conditions"',
            'local postfix = require("luasnip.extras.postfix").postfix',
            'local types = require "luasnip.util.types"',
            'local parse = require("luasnip.util.parser").parse_snippet',
            "local ms = ls.multi_snippet",
            "",
            "return {",
            "}",
        }
    ),
}
