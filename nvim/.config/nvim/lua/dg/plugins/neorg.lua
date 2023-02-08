local M = {
    "nvim-neorg/neorg",
    ft = "norg",
    build = ":Neorg sync-parsers",
    dependencies = "nvim-neorg/neorg-telescope",
}

function M.config()
    require("neorg").setup {
        load = {
            ["core.defaults"] = {}, -- Load all the default modules
            -- ["core.highlights"] = {
            --     config = {
            --         todo_items_match_color = "all",
            --     },
            -- },
            ["core.keybinds"] = { -- Configure core.keybinds
                config = {
                    -- TODO: customize keybinds so there are no gt* mappings (since those are used for tabs)
                    default_keybinds = true, -- Generate the default keybinds
                    neorg_leader = "<Leader>o", -- This is the default if unspecified
                },
            },
            ["core.norg.concealer"] = {
                config = {
                    -- icon_preset = "varied",
                    folds = false,
                    dim_code_blocks = {
                        width = "content",
                    },
                },
            },
            ["core.norg.completion"] = {
                config = {
                    engine = "nvim-cmp",
                },
            },
            ["core.norg.dirman"] = { -- Manage your directories with Neorg
                config = {
                    workspaces = {
                        notes = "~/Documents/text_files",
                    },
                    autochdir = true,
                },
            },
            ["core.norg.esupports.indent"] = {
                config = {
                    -- indents = {
                    --     _ = {
                    --         indent = 2,
                    --     }
                    -- }
                    tweaks = {
                        heading2 = 1,
                        heading3 = 2,
                        heading4 = 3,
                        heading5 = 4,
                        heading6 = 5,
                        unordered_list2 = 1,
                        unordered_list3 = 2,
                        unordered_list4 = 3,
                        unordered_list5 = 4,
                        unordered_list6 = 5,
                        ordered_list2 = 1,
                        ordered_list3 = 2,
                        ordered_list4 = 3,
                        ordered_list5 = 4,
                        ordered_list6 = 5,
                    },
                },
            },
            -- ["core.gtd.base"] = {},
            -- ["core.norg.journal"] = {},
            -- ["core.norg.qol.toc"] = {},
            -- ["core.presenter"] = {},
            -- ["core.norg.manoeuvre"] = {},
            ["core.integrations.telescope"] = {}, -- Enable the telescope module
        },
    }
end

return M
