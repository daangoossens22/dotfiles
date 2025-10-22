local M = {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
        "williamboman/mason.nvim", -- needs to be setup before the lsps are configured so that automatic_installation works
        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {
                library = {
                    -- { path = "luvit-meta/library", words = { "vim%.uv" } },
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    { path = "snacks.nvim",        words = { "Snacks" } },
                },
            },
        },
        {
            "stevearc/conform.nvim",
            opts = {
                formatters_by_ft = {
                    lua = { "stylua" },
                    sh = { "shellharden" },
                },
            },
        },
        -- "p00f/clangd_extensions.nvim",
        -- "simrat39/rust-tools.nvim",
        -- TODO: replace with builtin version https://github.com/neovim/neovim/pull/31959
        -- { url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },
    },
}

---@class PluginLspOpts
M.opts = {
    diagnostic = {
        underline = true,
        virtual_text = true,
        virtual_lines = false,
        -- signs = true,
        -- update_in_insert = false,
        severity_sort = true,
        jump = {
            float = true,
        },
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "󰅚",
                [vim.diagnostic.severity.WARN] = "󰀪",
                [vim.diagnostic.severity.INFO] = "󰋽",
                [vim.diagnostic.severity.HINT] = "󰌶",
            },
            texthl = {
                [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
                [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
                [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
                [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
            },
        },
    },
    additional_capabilities = {
        textDocument = {
            -- NOTE: for "kevinhwang91/nvim-ufo"
            -- foldingRange = {
            --     dynamicRegistration = false,
            --     lineFOldingOnly = true,
            -- },
        },
        -- semanticTokensProvider = nil
    },
    format = {
        timeout_ms = 5000,
    },
    servers = {
        -- pyright = {},
        basedpyright = {
            settings = {
                basedpyright = {
                    typeCheckingMode = "standard",
                },
            },
        },
        -- ruff_lsp = {},
        -- pylyzer = {},
        bashls = {},
        texlab = {},
        ts_ls = {},
        cssls = {},
        html = {},
        jsonls = {},
        ghdl_ls = {},
        -- arduino-language-server = {},
        rust_analyzer = {
            cmd = { "rustup", "run", "nightly", "rust-analyzer" },
            settings = {
                ["rust-analyzer"] = {
                    checkOnSave = {
                        command = "clippy",
                        -- extraArgs = { "--all", "--", "-W", "clippy::all" },
                        allTargets = false,
                    },
                },
            },
        },
        clangd = {
            cmd = {
                "clangd",
                "--all-scopes-completion",
                "--background-index",
                -- "--clang-tidy",
                -- "--completion-style=detailed",
                -- "--fallback-style=Microsoft",
                "--header-insertion=iwyu",
                "--header-insertion-decorators",
                "--inlay-hints",
                "--enable-config",
                "--offset-encoding=utf-16", -- NOTE: since cppcheck also uses that (and that cannot be configured)
            },
        },
        lua_ls = {
            settings = {
                Lua = {
                    telemetry = { enable = false },
                    -- diagnostics = { globals = { "vim", "describe", "it", "before_each" } },
                    completion = { callSnippet = "Replace" },
                    workspace = { checkThirdParty = true },
                    -- semantic = { enable = false },
                    hint = { enable = true },
                },
            },
        },
    },
}

---@param opts PluginLspOpts
function M.config(_, opts)
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    local function toggle_autoformat(lang)
        lang = lang or vim.bo.filetype
        AUTOFORMAT_LANGUAGES[lang] = not AUTOFORMAT_LANGUAGES[lang]
    end
    local function lsp_format(bufnr)
        bufnr = bufnr or 0
        require("conform").format {
            bufnr = bufnr,
            timeout_ms = 500,
            lsp_format = "fallback",
            quiet = true,
        }
    end
    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function(args)
            if AUTOFORMAT_LANGUAGES[vim.bo.filetype] then lsp_format(args.buf) end
        end,
        group = AUGROUP "lsp_autoformat",
    })

    vim.diagnostic.config(vim.deepcopy(opts.diagnostic))
    local function diag_opts(desc) return { silent = true, desc = "[DIAG] " .. desc } end
    MAP("n", "<leader>e", function()
        local virtual_lines = vim.diagnostic.config().virtual_lines
        vim.diagnostic.config {
            -- update_in_insert = virtual_lines,
            virtual_lines = not virtual_lines,
            virtual_text = virtual_lines,
        }
    end, diag_opts "toggle diagnostics on same or on new lines below")
    MAP("n", "<leader>ut", function()
        local underline = vim.diagnostic.config().underline
        vim.diagnostic.config {
            underline = not underline,
        }
    end, diag_opts "toggle diagnostics underline")
    MAP(
        "n",
        "[d",
        function() vim.diagnostic.jump { count = -1 } end,
        diag_opts "move to the previous buffer diagnostic"
    )
    MAP(
        "n",
        "]d",
        function() vim.diagnostic.jump { count = 1 } end,
        diag_opts "move to the next buffer diagnostic"
    )
    MAP(
        "n",
        "[w",
        function() vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.WARN } end,
        diag_opts "move to the previous buffer diagnostic warning"
    )
    MAP(
        "n",
        "]w",
        function() vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.WARN } end,
        diag_opts "move to the next buffer diagnostic warning"
    )
    MAP(
        "n",
        "[e",
        function() vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR } end,
        diag_opts "move to the previous buffer diagnostic error"
    )
    MAP(
        "n",
        "]e",
        function() vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR } end,
        diag_opts "move to the next buffer diagnostic error"
    )
    MAP("n", "<leader>qq", function()
        if next(vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR })) == nil then
            vim.diagnostic.setqflist { severity = vim.diagnostic.severity.WARN }
        else
            vim.diagnostic.setqflist { severity = vim.diagnostic.severity.ERROR }
        end
    end, diag_opts "add project diagnostics to the qflist (ERRORS, otherwise WARNINGS)")
    MAP(
        "n",
        "<leader>th",
        function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
        { silent = true, desc = "[LSP] toggle inlay hints for the current buffer" }
    )

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local lb = vim.lsp.buf
            local function lsp_opts(desc) return { buffer = true, silent = true, desc = "[LSP] " .. desc } end

            MAP("n", "gra", lb.code_action, lsp_opts "code actions under the cursor")
            MAP("n", "grn", lb.rename, lsp_opts "rename variable under the cursor project wide")
            MAP("n", "<leader>cl", vim.lsp.codelens.run, lsp_opts "run one of the codelens actions")
            MAP("n", "gD", lb.declaration, lsp_opts "jumps to the declaration of the symbol under the cursor")
            -- MAP(
            --     "n",
            --     "gri",
            --     lb.implementation,
            --     lsp_opts "list all implementations for the symbol under the cursor"
            -- )
            MAP(
                { "n", "i", "s" },
                "<C-s>",
                lb.signature_help,
                lsp_opts "display signature information about the symbol under the cursor"
            )
            MAP(
                "n",
                "<leader>D",
                lb.type_definition,
                lsp_opts "jumps to the definition of the type of the symbol under the cursor"
            )
            MAP("n", "gqb", lsp_format, lsp_opts "formats the current buffer")
            MAP("n", "<leader>laf", toggle_autoformat, lsp_opts "toggle format current buffer on write")
        end,
    })

    local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities(),
        -- require("blink.cmp").get_lsp_capabilities(),
        opts.additional_capabilities
    )

    for lsp, lsp_opts in pairs(opts.servers) do
        local new_lsp_opts = vim.tbl_deep_extend("force", {
            capabilities = capabilities,
        }, lsp_opts)
        require("lspconfig")[lsp].setup(new_lsp_opts)
    end

    -- vim.cmd [[autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh({ bufnr = 0 })]]
end

return M
