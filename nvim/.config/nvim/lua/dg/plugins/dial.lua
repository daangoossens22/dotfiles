local M = {
    "monaqa/dial.nvim",
    keys = {
        { "<C-a>", function() require("dial.map").manipulate("increment", "normal") end, desc = "[DIAL] increment" },
        { "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end, desc = "[DIAL] decrement" },
        {
            "<C-a>",
            function() require("dial.map").manipulate("increment", "visual") end,
            mode = "x",
            desc = "[DIAL] increment",
        },
        {
            "<C-x>",
            function() require("dial.map").manipulate("decrement", "visual") end,
            mode = "x",
            desc = "[DIAL] decrement",
        },
    },
}

function M.config(_, opts)
    local augend = require "dial.augend"
    require("dial.config").augends:register_group {
        default = {
            augend.integer.alias.decimal_int,
            augend.integer.alias.binary,
            augend.integer.alias.hex,
            augend.integer.alias.octal,
            augend.hexcolor.new {
                radix = 16,
                prefix = "0x",
                natural = true,
                case = "upper",
            },
            augend.hexcolor.new {
                case = "lower",
            },
            augend.constant.alias.bool,
            augend.date.alias["%d/%m/%Y"],
            augend.date.alias["%H:%M:%S"],
            augend.date.alias["%H:%M"],
            augend.semver.alias.semver,
        },
    }
end

return M
