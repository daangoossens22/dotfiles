local M = {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "onsails/lspkind-nvim",
        "saadparwaiz1/cmp_luasnip",
        {
            "tamago324/cmp-zsh",
            opts = {
                -- zshrc = true,
                filetypes = { "zsh" },
            },
        },
        -- { "kdheepak/cmp-latex-symbols", pin = true }
        -- "octaltree/cmp-look"
        -- "Saecki/crates.nvim"
    },
}

function M.config()
    vim.opt.completeopt = { "menu", "menuone", "noselect" }

    local cmp = require "cmp"
    local complete_fallback = function(f)
        return function()
            if cmp.visible() then
                f()
            else
                cmp.complete()
            end
        end
    end

    cmp.setup {
        snippet = {
            expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        window = {
            -- completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
        },
        mapping = {
            ["<C-p>"] = cmp.mapping(complete_fallback(cmp.mapping.select_prev_item()), { "i" }),
            ["<C-n>"] = cmp.mapping(complete_fallback(cmp.mapping.select_next_item()), { "i" }),
            ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i" }),
            ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i" }),
            ["<C-e>"] = cmp.mapping(cmp.mapping.abort(), { "i", "c" }),
            -- ["<C-e>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" }),
            ["<C-l>"] = cmp.mapping(cmp.mapping.complete_common_string(), { "i", "c" }),
            ["<C-Space>"] = cmp.mapping(
                cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true },
                { "i", "c" }
            ),
        },
        sources = cmp.config.sources {
            { name = "nvim_lsp" },
            { name = "luasnip", max_item_count = 4 },
            { name = "path" }, -- could use builtin i_CTRL-X_CTRL-F
            { name = "zsh" },
            { name = "neorg" },
            { name = "buffer", keyword_length = 5 },
        },
        sorting = {
            priority_weight = 2,
            comparators = {
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                -- cmp.config.compare.scopes,
                cmp.config.compare.score,
                cmp.config.compare.locality,
                cmp.config.compare.recently_used,

                -- REF: lukas-reineke/cmp-under-comparator
                function(entry1, entry2)
                    local _, entry1_under = entry1.completion_item.label:find "^_+"
                    local _, entry2_under = entry2.completion_item.label:find "^_+"
                    entry1_under = entry1_under or 0
                    entry2_under = entry2_under or 0
                    if entry1_under > entry2_under then
                        return false
                    elseif entry1_under < entry2_under then
                        return true
                    end
                end,

                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
            },
        },
        formatting = {
            format = require("lspkind").cmp_format {
                mode = "text",
                menu = {
                    nvim_lsp = "[LSP]",
                    luasnip = "[snip]",
                    buffer = "[buf]",
                    neorg = "[norg]",
                    zsh = "[zsh]",
                    -- path = "[path]",
                    -- cmdline = "[cmd]",
                },
            },
        },
        -- experimental = {
        --     ghost_text = true,
        -- },
    }

    -- NOTE: doesn't work if `native_menu` is enabled
    local cmdline_mappings = {
        ["<C-n>"] = cmp.mapping(function()
            local key = vim.api.nvim_replace_termcodes("<Down>", true, false, true)
            if cmp.visible() then
                cmp.select_next_item()
            else
                vim.api.nvim_feedkeys(key, "c", false)
            end
        end, { "c" }),
        ["<C-p>"] = cmp.mapping(function()
            local key = vim.api.nvim_replace_termcodes("<Up>", true, false, true)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                vim.api.nvim_feedkeys(key, "c", false)
            end
        end, { "c" }),
        ["<Tab>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_next_item()
            else
                cmp.complete()
            end
        end, { "c" }),
    }
    cmp.setup.cmdline("/", {
        completion = {
            autocomplete = false,
        },
        mapping = cmdline_mappings,
        -- mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer", keyword_length = 5 },
        },
    })
    cmp.setup.cmdline(":", {
        completion = {
            autocomplete = false,
        },
        view = {
            entries = { name = "wildmenu", separator = "|" },
        },
        mapping = cmdline_mappings,
        -- mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources {
            { name = "path" }, -- start path with ~/ or ./ for it to work
            { name = "cmdline" },
        },
    })
end

return M
