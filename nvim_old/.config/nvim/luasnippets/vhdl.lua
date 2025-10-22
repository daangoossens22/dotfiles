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

local rec_case
rec_case = function()
    return sn(nil, {
        c(1, {
            t { "" },
            sn(nil, {
                t { "", "\twhen " },
                i(1),
                t " => ",
                i(2),
                t ";",
                d(3, rec_case, {}),
            }),
            sn(nil, { t { "", "\twhen others => " }, i(1, "'0'"), t ";" }),
        }),
    })
end

local rec_if
rec_if = function()
    return sn(nil, {
        c(1, {
            t { "" },
            sn(nil, {
                t { "", "elsif " },
                i(1),
                t " then",
                t { "", "\t" },
                i(2),
                d(3, rec_if, {}),
            }),
            sn(nil, { t { "", "else " }, t { "", "\t" }, i(1), d(2, rec_if, {}) }),
        }),
    })
end

-- local vector_snip = function(vec_name)
--     return fmt(vec_name .. [[({} {} {})]], { i(1, "7"), c(2, { i(nil, "downto"), i(nil, "to") }), i(3, "0") })
-- end

return {
    s("vhdloo", t "hello, world!"),
    s(
        "if",
        fmt(
            [[
    if {} then
    {}{}{}
    end if;
    ]],
            { i(1), t "\t", i(2), d(3, rec_if, {}) }
        )
    ),

    s(
        "case",
        fmt(
            [[
    case {} is{}
    end case;
    ]],
            { i(1), d(2, rec_case, {}) }
        )
    ),

    s(
        "ent",
        fmt(
            [[
entity {} is{}{}
end {};
    ]],
            {
                d(1, function(_, parent) return sn(nil, i(1, parent.snippet.env.TM_FILENAME_BASE)) end, {}),
                c(2, {
                    sn(nil, { t { "", "\tgeneric(", "\t\t" }, i(1), t { "", "\t);" } }),
                    t { "" },
                }),
                c(3, {
                    sn(nil, { t { "", "\tport(", "\t\t" }, i(1), t { "", "\t);" } }),
                    t { "" },
                }),
                rep(1),
            }
        )
    ),

    s(
        "epm",
        fmt(
            [[
    {}: entity work.{}{}
    {}port map({});
    ]],
            {
                i(1, "dut"),
                i(2),
                c(3, {
                    sn(nil, { t { "", "\tgeneric map(" }, i(1), t ")" }),
                    t { "" },
                }),
                t "\t",
                i(4),
            }
        )
    ),

    s(
        "p",
        fmt([[{} => {},]], {
            i(1),
            d(2, function(args, _)
                local text = args[1][1] or ""
                return sn(nil, {
                    i(1, text),
                })
            end, { 1 }),
        })
    ),

    -- s("std", vector_snip "std_logic_vector"),
    -- s("stdu", vector_snip "std_ulogic_vector"),
    -- TODO: auto fill component
    -- TODO: auto fill in entity port_map CLK => ..., other params => ...
    -- TODO: add snippet for inside port and generic stuff that expand infinitely with <c-;>
}
