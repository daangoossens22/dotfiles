local M = {
    "monaqa/dial.nvim",
    keys = { "<C-a>", "<C-x>" },
}

function M.config()
    local augend = require "dial.augend"
    require("dial.config").augends:register_group {
        -- default augends used when no group name is specified
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
            -- augend.date.alias["%Y-%m-%d"], -- TODO: why does this produce errors when in d/m/y format
            augend.date.alias["%H:%M:%S"],
            augend.date.alias["%H:%M"],
            augend.semver.alias.semver,
        },
    }

    local dial_map = require "dial.map"
    MAP("n", "<C-a>", dial_map.inc_normal())
    MAP("n", "<C-x>", dial_map.dec_normal())
    MAP("v", "<C-a>", dial_map.inc_visual())
    MAP("v", "<C-x>", dial_map.dec_visual())
    MAP("v", "g<C-a>", dial_map.inc_gvisual())
    MAP("v", "g<C-x>", dial_map.dec_gvisual())
end

return M
