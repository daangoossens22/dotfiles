local M = {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = {
        "rafamadriz/friendly-snippets",
        "nvim-treesitter/nvim-treesitter",
    },
}

function M.init()
    MAP({ "i", "s" }, "<C-k>", function()
        if require("luasnip").expand_or_jumpable() then require("luasnip").expand_or_jump() end
    end, { silent = true, desc = "[SNIP] expand snippet or jump to next snippet field" })
    MAP({ "i", "s" }, "<C-j>", function()
        if require("luasnip").jumpable(-1) then require("luasnip").jump(-1) end
    end, { silent = true, desc = "[SNIP] jump to prev snippet field" })

    MAP({ "i", "s" }, "<C-'>", function()
        if require("luasnip").choice_active() then require("luasnip").change_choice(1) end
    end, { desc = "[SNIP] change snippet version" })
    MAP({ "i", "s" }, "<C-;>", function()
        if require("luasnip").choice_active() then require("luasnip").change_choice(-1) end
    end, { desc = "[SNIP] change snippet version" })
end

function M.config()
    local ls = require "luasnip"
    local types = require "luasnip.util.types"

    require("luasnip").config.setup {
        history = true, -- be able to go back to last selection

        -- https://github.com/L3MON4D3/LuaSnip/issues/78
        region_check_events = "CursorMoved",
        delete_check_events = "TextChanged",

        updateevents = "TextChanged,TextChangedI",

        -- enable_autosnippets = true,

        store_selection_keys = "<C-k>",

        ext_opts = {
            [types.choiceNode] = {
                active = {
                    virt_text = { { "<-", "Error" } },
                },
            },
        },
        ft_func = function() return require("luasnip.extras.filetype_functions").from_pos_or_filetype() end,
    }

    -- load friendly-snippts
    require("luasnip.loaders.from_vscode").lazy_load {}
    require("luasnip.loaders.from_lua").lazy_load {
        path = "~/.config/nvim/luasnippets",
        default_priority = 2000,
    }
end

return M
