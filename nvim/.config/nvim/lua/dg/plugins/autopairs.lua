local M = {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
}

function M.config()
    require("nvim-autopairs").setup {
        check_ts = true,
        -- ts_config = { java = false },
    }
    -- If you want insert `(` after select function or method item
    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    local cmp = require "cmp"
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    local Rule = require "nvim-autopairs.rule"
    local cond = require "nvim-autopairs.conds"

    require("nvim-autopairs").add_rules {
        Rule("$", "$", "tex"),

        Rule(" ", " "):with_pair(function(opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return pair == "{}"
        end),
        Rule("{ ", " }")
            :with_pair(function() return false end)
            :with_move(function(opts) return opts.prev_char:match ".%}" ~= nil end)
            :use_key "}",
    }

    -- TODO(lua): add rule for function and if statement to insert the end
    -- TODO: add way to easily cancel a pair in insert mode
    -- TODO: when adding brackets and pressing space add 2 spaces e.g. '" |' results in '" | "'
    -- TODO: check `check_ts` and `ts_config` config options
    -- TODO: check out the `fast_wrap` config option
end

return M
