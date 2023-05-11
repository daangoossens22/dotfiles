local M = {
    "nvim-neorg/neorg",
    ft = "norg",
    build = ":Neorg sync-parsers",
    cmd = { "Neorg" },
    dependencies = "nvim-neorg/neorg-telescope",
}

function M.init()
    MAP("n", "<Leader>ni", "<cmd>Neorg index<CR>", { silent = true })
    MAP("n", "<Leader>nr", "<cmd>Neorg return<CR>", { silent = true })
end

function M.config()
    require("neorg").setup {
        load = {
            -- default modules
            ["core.defaults"] = {},
            ["core.esupports.indent"] = {
                config = {
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
            ["core.keybinds"] = {
                config = {
                    -- TODO: customize keybinds so there are no gt* mappings (since those are used for tabs)
                    default_keybinds = true,
                    neorg_leader = "<Leader>",
                },
            },
            -- other modules
            ["core.completion"] = { config = { engine = "nvim-cmp" } },
            ["core.concealer"] = {
                config = {
                    dim_code_blocks = { conceal = false, width = "content" },
                    icon_preset = "diamond",
                    icons = {
                        todo = {
                            undone = { enabled = false },
                            done = { icon = "", highlight = "@neorg.todo_items.done.1" },
                            uncertain = { icon = "?", highlight = "@neorg.todo_items.uncertain.1" },

                            urgent = { icon = "", highlight = "@neorg.todo_items.urgent.1" },
                            recurring = { icon = "", highlight = "@neorg.todo_items.recurring.1" },

                            pending = { icon = "󰅐", highlight = "@neorg.todo_items.pending.1" },
                            on_hold = { icon = "", highlight = "@neorg.todo_items.on_hold.1" },
                            cancelled = { icon = "󰩹", highlight = "@neorg.todo_items.cancelled.1" },
                        },
                    },
                },
            },
            ["core.dirman"] = {
                config = {
                    workspaces = {
                        notes = "~/Documents/text_files",
                    },
                    default_workspace = "notes",
                    autochdir = true,
                },
            },
            ["core.export"] = {},
            ["core.export.markdown"] = {},
            ["core.integrations.telescope"] = {},
        },
    }
end

return M
