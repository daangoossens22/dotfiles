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
        -- "hrsh7th/cmp-nvim-lua"
        -- { "kdheepak/cmp-latex-symbols", pin = true }
        -- "octaltree/cmp-look"
    },
}

function M.config()
    vim.opt.completeopt = { "menu", "menuone", "noselect" }

    local cmp = require "cmp"
    cmp.setup {
        snippet = {
            expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        window = {
            -- completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
        },
        mapping = {
            -- TODO: add mappings for`close`, `abort`, `complete`, `complete_common_string`
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<C-Space>"] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            },
            -- ["<CR>"] = cmp.mapping.confirm {
            --     behavior = cmp.ConfirmBehavior.Insert,
            --     select = false,
            -- },
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
                    nvim_lua = "[api]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[snip]",
                    buffer = "[buf]",
                    neorg = "[norg]",
                },
            },
        },
        experimental = {
            ghost_text = true,
        },
    }

    -- NOTE: doesn't work if `native_menu` is enabled
    -- NOTE: both disabled for now
    cmp.setup.cmdline("/", {
        completion = {
            autocomplete = false,
        },
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer", keyword_length = 5 },
        },
    })
    cmp.setup.cmdline(":", {
        completion = {
            autocomplete = false,
        },
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources {
            { name = "path" }, -- start path with ~/ or ./ for it to work
            { name = "cmdline" },
        },
    })
    MAP("c", "<C-n>", '<cmd>lua require("cmp").complete()<cr>') -- to start completion when autocomplete is turned off
end

return M
