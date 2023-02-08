local M = {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = "rafamadriz/friendly-snippets",
}

function M.config()
    local ls = require "luasnip"
    local types = require "luasnip.util.types"

    require("luasnip").config.setup {
        history = true, -- be able to go back to last selection

        -- https://github.com/L3MON4D3/LuaSnip/issues/78
        region_check_events = "CursorMoved",
        delete_check_events = "TextChanged",

        updateevents = "TextChanged,TextChangedI",

        enable_autosnippets = true,

        ext_opts = {
            [types.choiceNode] = {
                active = {
                    virt_text = { { "<-", "Error" } },
                },
            },
        },
    }

    -- load friendly-snippts
    require("luasnip.loaders.from_vscode").lazy_load()

    -- keymaps
    MAP({ "i", "s" }, "<C-k>", function()
        if ls.expand_or_jumpable() then ls.expand_or_jump() end
    end, { silent = true, desc = "[SNIP] expand snippet or jump to next snippet field" })

    MAP({ "i", "s" }, "<C-j>", function()
        if ls.jumpable(-1) then ls.jump(-1) end
    end, { silent = true, desc = "[SNIP] jump to prev snippet field" })

    MAP("i", "<C-;>", function()
        if ls.choice_active() then ls.change_choice(1) end
    end, { desc = "[SNIP] change snippet version" })
    MAP(
        "n",
        "<leader><leader>s",
        "<cmd>source ~/.config/nvim/lua/dg/luasnip.lua<CR>",
        "[SNIP] reload snippets"
    )

    -- TODO: move to own file (for each language)
    local s = ls.s
    local fmt = require("luasnip.extras.fmt").fmt
    local rep = require("luasnip.extras").rep

    local i = ls.insert_node
    local t = ls.text_node
    local d = ls.dynamic_node
    local c = ls.choice_node
    local f = ls.function_node

    local require_var = function(args, _)
        local text = args[1][1] or ""
        local split = vim.split(text, ".", { plain = true })

        local options = {}
        for len = 0, #split - 1 do
            table.insert(options, t(table.concat(vim.list_slice(split, #split - len, #split), "_")))
        end

        return ls.sn(nil, {
            c(1, options),
        })
    end

    ls.add_snippets("all", {})

    ls.add_snippets("lua", {
        ls.parser.parse_snippet("lf", "$1 = function($2)\n\t$0\nend"),
        s("req", fmt([[local {} = require('{}')]], { d(2, require_var, { 1 }), i(1) })), -- TODO: change 2nd spot to selection after <C-j>
        s(
            "ok",
            fmt(
                [[
                if not pcall(require, "{}") then
                    return
                end
                ]],
                { i(1) }
            )
        ),
    })

    ls.add_snippets("python", {
        s(
            "main",
            fmt(
                [[
                if __name__ == "__main__":
                    {}
                ]],
                { i(1, "pass") }
            )
        ),
    })

    ls.add_snippets("cpp", {
        s(
            "main",
            fmt(
                [[
                int main({})
                {{
                    {}
                }}
                ]],
                { c(1, { t "", t "int argc, char* argv[]" }), i(2) }
            )
        ),

        s("tern", fmt([[{} ? {} : {};]], { i(1), i(2), i(3) })),

        s(
            "for",
            fmt(
                [[
                for ({} {} = {}; {} < {}; ++{})
                {{
                    {}
                }}
                ]],
                { i(1, "size_t"), i(2, "i"), i(3), rep(2), i(4), rep(2), i(5) }
            )
        ),
    })
end

return M
