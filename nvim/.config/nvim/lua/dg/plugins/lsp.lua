local M = {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {
                library = {
                    -- { path = "luvit-meta/library", words = { "vim%.uv" } },
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    { path = "snacks.nvim", words = { "Snacks" } },
                },
            },
        },
    },
}

---@class PluginLspOpts
M.opts = {
    diagnostic = {
        underline = true,
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
        harper_ls = {
            filetypes = {
                "c",
                "cpp",
                "cs",
                "gitcommit",
                "go",
                "html",
                "java",
                "javascript",
                "lua",
                "markdown",
                "nix",
                "python",
                "ruby",
                "rust",
                "swift",
                "toml",
                "typescript",
                "typescriptreact",
                "haskell",
                "cmake",
                "typst",
                "php",
                "dart",
                "clojure",
                "sh",
                "tex",
                "bib",
            },
            settings = {
                ["harper-ls"] = {
                    linters = {
                        LongSentences = false,
                        NoFrenchSpaces = false,
                        Spaces = false,
                    },
                },
            },
        },
        -- arduino-language-server = {},
        -- veridian = {
        --     root_dir = function(bufnr, on_dir)
        --         on_dir(vim.fs.root(bufnr, { "veridian.yml", ".git" }) or vim.fn.getcwd())
        --     end,
        -- },
        verible = {
            cmd = { "verible-verilog-ls", "--lsp_enable_hover", "--rules_config_search" },
            root_dir = function(bufnr, on_dir)
                on_dir(vim.fs.root(bufnr, { "verible.filelist", ".rules.verible_lint", ".git" }) or vim.fn.getcwd())
            end,
        },
        svlangserver = {
            root_dir = function(bufnr, on_dir)
                on_dir(vim.fs.root(bufnr, { ".svlangserver", ".git" }) or vim.fn.getcwd())
            end,
            settings = {
                systemverilog = {
                    disableHoverProvider = true,
                    -- disableLinting = true,
                    -- disableSignatureHelpProvider = true,
                    -- disableCompletionProvider = true,
                },
            },
        },
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
                    completion = { callSnippet = "Replace" },
                    workspace = { checkThirdParty = true },
                    -- semantic = { enable = false },
                    hint = { enable = true },
                },
            },
        },
    },
}

local function diagnostic_jump(opts)
    local augroup = AUGROUP "lsp_diagnostic_jump"
    pcall(vim.api.nvim_del_augroup_by_name, augroup)

    vim.diagnostic.jump(opts)

    -- local virtual_text = vim.diagnostic.config().virtual_text
    -- vim.diagnostic.config {
    --     virtual_text = false,
    --     virtual_lines = { current_line = true },
    -- }
    --
    -- vim.defer_fn(function()
    --     vim.api.nvim_create_autocmd("CursorMoved", {
    --         once = true,
    --         group = augroup,
    --         callback = function() vim.diagnostic.config { virtual_lines = false, virtual_text = virtual_text } end,
    --     })
    -- end, 1)
end
M.keys = {
    {
        "<leader>ut",
        function()
            local underline = vim.diagnostic.config().underline
            vim.diagnostic.config {
                underline = not underline,
            }
        end,
        silent = true,
        desc = "[DIAG] toggle diagnostics underline",
    },
    {

        "[w",
        function() diagnostic_jump { count = -1, severity = vim.diagnostic.severity.WARN } end,
        silent = true,
        desc = "[DIAG] move to the previous buffer diagnostic warning",
    },
    {

        "]w",
        function() diagnostic_jump { count = 1, severity = vim.diagnostic.severity.WARN } end,
        silent = true,
        desc = "[DIAG] move to the next buffer diagnostic warning",
    },
    {

        "[e",
        function() diagnostic_jump { count = -1, severity = vim.diagnostic.severity.ERROR } end,
        silent = true,
        desc = "[DIAG] move to the previous buffer diagnostic error",
    },
    {

        "]e",
        function() diagnostic_jump { count = 1, severity = vim.diagnostic.severity.ERROR } end,
        silent = true,
        desc = "[DIAG] move to the next buffer diagnostic error",
    },
    {
        "<leader>qq",
        function()
            if next(vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR })) == nil then
                vim.diagnostic.setqflist { severity = vim.diagnostic.severity.WARN }
            else
                vim.diagnostic.setqflist { severity = vim.diagnostic.severity.ERROR }
            end
        end,
        silent = true,
        desc = "[DIAG] add project diagnostics to the qflist (ERRORS, otherwise WARNINGS)",
    },
}

---@param opts PluginLspOpts
function M.config(_, opts)
    -- get lsp folds when available
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client:supports_method "textDocument/foldingRange" then
                local win = vim.api.nvim_get_current_win()
                vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
            end
        end,
        group = AUGROUP "set_lsp_foldexpr_when_available",
    })
    vim.api.nvim_create_autocmd("LspDetach", {
        command = "setl foldexpr<",
        group = AUGROUP "unset_lsp_foldexpr_on_lspdetach",
    })

    -- disable semantic tokens for comments, so it doesn't override treesitters comment parsers tokens
    vim.api.nvim_set_hl(0, "@lsp.type.comment", {})

    vim.diagnostic.config(vim.deepcopy(opts.diagnostic))

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local function lsp_opts(desc) return { buffer = true, silent = true, desc = "[LSP] " .. desc } end

            vim.keymap.set(
                "n",
                "grd",
                vim.lsp.buf.declaration,
                lsp_opts "jumps to the declaration of the symbol under the cursor"
            )
            vim.keymap.set(
                { "n", "i" },
                "<C-s>",
                vim.lsp.buf.signature_help,
                lsp_opts "display signature information about the symbol under the cursor"
            )

            vim.keymap.set(
                "n",
                "<leader>th",
                function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
                { silent = true, desc = "[LSP] toggle inlay hints for the current buffer" }
            )
        end,
    })

    for lsp, lsp_opts in pairs(opts.servers) do
        vim.lsp.config(lsp, lsp_opts)
        vim.lsp.enable(lsp)
    end
end

return M
