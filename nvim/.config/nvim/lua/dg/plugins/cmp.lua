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
        -- "tamago324/cmp-zsh",
        -- { "kdheepak/cmp-latex-symbols", pin = true }
        -- "octaltree/cmp-look"
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
            ["<C-p>"] = cmp.mapping(complete_fallback(cmp.mapping.select_prev_item()), { "i", "c" }),
            ["<C-n>"] = cmp.mapping(complete_fallback(cmp.mapping.select_next_item()), { "i", "c" }),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
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
            { name = "neorg" },
            { name = "buffer", keyword_length = 5 },
        },
        formatting = {
            format = require("lspkind").cmp_format {
                mode = "text",
                menu = {
                    nvim_lsp = "[LSP]",
                    luasnip = "[snip]",
                    buffer = "[buf]",
                    neorg = "[norg]",
                    -- path = "[path]",
                    -- cmdline = "[cmd]",
                },
            },
        },
        experimental = {
            ghost_text = true,
        },
    }

    -- NOTE: doesn't work if `native_menu` is enabled
    cmp.setup.cmdline("/", {
        completion = {
            autocomplete = false,
        },
        -- mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer", keyword_length = 5 },
        },
    })
    cmp.setup.cmdline(":", {
        completion = {
            autocomplete = false,
        },
        -- mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources {
            { name = "path" }, -- start path with ~/ or ./ for it to work
            { name = "cmdline" },
        },
    })
end

return M
