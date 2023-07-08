local M = {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = "hrsh7th/nvim-cmp",
}

function M.config()
    local autopairs = require "nvim-autopairs"
    autopairs.setup {
        -- disable_filetype = { "TelescopePrompt", "spectre_panel" },
        disable_in_macro = true,
        disable_in_visualblock = true,
        -- disable_in_replace_mode = true,
        -- ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
        -- enable_moveright = true,
        enable_afterquote = false,
        -- enable_check_bracket_line = true,
        -- enable_bracket_in_quote = true,
        -- enable_abbr = false,
        -- break_undo = true,
        check_ts = true,
        ts_config = {
            -- lua = { "comment" },
        },
        -- map_cr = true,
        -- map_bs = true,
        -- map_c_h = false,
        -- map_c_w = false,
        fast_wrap = {
            -- map = "<M-e>",
            -- chars = { "{", "[", "(", '"', "'" },
            -- pattern = [=[[%'%"%>%]%)%}%,]]=],
            -- end_key = "$",
            -- keys = "qwertyuiopzxcvbnmasdfghjkl",
            -- check_comma = true,
            -- manual_position = true,
            -- highlight = "Search",
            -- highlight_grey = "Comment",
        },
    }
    -- If you want insert `(` after select function or method item
    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    local cmp = require "cmp"
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    local Rule = require "nvim-autopairs.rule"
    local cond = require "nvim-autopairs.conds"
    local ts_conds = require "nvim-autopairs.ts-conds"

    autopairs.clear_rules()
    autopairs.add_rules {
        Rule("$", "$", "tex"),

        Rule(" ", " "):with_pair(function(opts) return opts.line:sub(opts.col - 1, opts.col) == "{}" end),
        -- Rule("{ ", " }")
        --     :with_pair(function() return false end)
        --     :with_move(function(opts) return opts.prev_char:match ".%}" ~= nil end)
        --     :use_key "}",

        Rule("then", "end", "lua"):end_wise(
            function(opts) return string.match(opts.line, "^%s*if") ~= nil end
        ),
        Rule("do", "end", "lua"):end_wise(
            function(opts)
                return string.match(opts.line, "^%s*while") ~= nil
                    or string.match(opts.line, "^%s*for") ~= nil
            end
        ),
        Rule("", "end", "lua"):end_wise(
            function(opts) return string.match(opts.line, "function.*%(.*%)$") ~= nil end
        ),
    }

    for _, token in pairs { "*", "/", "$", "_", "!", "^", ",", "&", "%" } do
        autopairs.add_rules {
            Rule(token, token, "norg")
                :with_pair(function(opts)
                    if token == "*" then
                        if opts.line:match "^%s*$" then
                            return false
                        else
                            return nil
                        end
                    else
                        return nil
                    end
                end)
                :with_pair(function(opts) return opts.line:sub(opts.col - 1) == " " end)
                :with_move(function() return true end),
        }
    end

    for _, punct in pairs { ",", ";" } do
        autopairs.add_rules {
            Rule("", punct)
                :with_move(function() return true end)
                :with_pair(function() return false end)
                :with_del(function() return false end)
                :with_cr(function() return false end)
                :use_key(punct),
        }
    end

    -- TODO: check if this plugin can be removed by using luasnip autosnippets
    -- TODO: remove all default pairs and just make your own (easier to maintain)
end

return M
