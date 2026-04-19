local M = {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts_extend = { "sources.default" },
}

---@module 'blink.cmp'
---@type blink.cmp.Config
M.opts = {
    keymap = {
        preset = "default",

        ["<Tab>"] = false,
        ["<S-Tab>"] = false,
        ["<C-j>"] = { "snippet_forward", "fallback" },
        ["<C-k>"] = { "snippet_backward", "fallback" },
        ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
    },

    appearance = {
        nerd_font_variant = "mono",
    },

    completion = { documentation = { auto_show = false } },
    signature = { enabled = true },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
            lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                score_offset = 100,
            },
        },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" },
}

return M
