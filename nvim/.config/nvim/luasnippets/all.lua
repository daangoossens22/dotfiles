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

local function pair(pair_begin, pair_end)
    return s({
        trig = pair_begin,
        wordTrig = false,
        -- show_condition = function() return false end,
    }, {
        t(pair_begin),
        c(1, {
            r(1, "inside_pairs"),
            sn(nil, {
                t { "", "\t" },
                r(1, "inside_pairs"),
                t { "", "" },
            }),
        }),
        t(pair_end),
    }, { stored = { ["inside_pairs"] = i(1) } })
end

return {
    pair("(", ")"),
    pair("{", "}"),
    pair("{", "}"),
    pair("[", "]"),
    pair("<", ">"),
    pair("'", "'"),
    pair('"', '"'),
    pair("`", "`"),
}
