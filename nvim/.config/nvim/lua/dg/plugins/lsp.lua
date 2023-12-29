local M = {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
        "williamboman/mason.nvim", -- needs to be setup before the lsps are configured so that automatic_installation works
        {
            "jose-elias-alvarez/null-ls.nvim",
            opts = function()
                local null_ls = require "null-ls"
                return {
                    sources = {
                        null_ls.builtins.formatting.stylua,
                        null_ls.builtins.formatting.prettier,
                        null_ls.builtins.formatting.yapf,
                        null_ls.builtins.formatting.shellharden,
                        null_ls.builtins.formatting.emacs_vhdl_mode,
                        -- null_ls.builtins.formatting.cbfmt, -- format embedded codeblock in markdown
                        null_ls.builtins.diagnostics.shellcheck,
                        null_ls.builtins.code_actions.shellcheck,
                        -- null_ls.builtins.diagnostics.zsh,
                        null_ls.builtins.diagnostics.cppcheck,
                        null_ls.builtins.diagnostics.glslc.with {
                            extra_args = {
                                "-fauto-map-locations",
                                "--target-env=opengl",
                            },
                        },
                    },
                }
            end,
        },
        {
            "folke/neodev.nvim",
            opts = {
                -- setup_jsonls = false,
                -- library = {
                --     plugins = false,
                -- },
            },
        },
        -- "p00f/clangd_extensions.nvim",
        -- "simrat39/rust-tools.nvim",
        { url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },
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
        ignore_lsp = { "lua_ls", "jedi_language_server" },
        timeout_ms = 5000,
    },
    servers = {
        pyright = {},
        -- ruff_lsp = {},
        -- pylyzer = {},
        bashls = {},
        texlab = {},
        tsserver = {},
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
                -- '--fallback-style="Microsoft"',
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
                    workspace = { checkThirdParty = false },
                    -- semantic = { enable = false },
                    hint = { enable = true },
                },
            },
        },
    },
}

---@param opts PluginLspOpts
function M.config(_, opts)
    local function toggle_autoformat(lang)
        lang = lang or vim.bo.filetype
        AUTOFORMAT_LANGUAGES[lang] = not AUTOFORMAT_LANGUAGES[lang]
    end

    local function lsp_format()
        vim.lsp.buf.format {
            filter = function(format_client)
                return not vim.tbl_contains(opts.format.ignore_lsp, format_client.name)
            end,
            timeout_ms = opts.format.timeout_ms,
        }
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
            if AUTOFORMAT_LANGUAGES[vim.bo.filetype] then lsp_format() end
        end,
        group = AUGROUP "lsp_autoformat",
    })

    vim.fn.sign_define("DiagnosticSignError", { text = "󰅚", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = "󰀪", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = "󰋽", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "󰌶", texthl = "DiagnosticSignHint" })
    vim.diagnostic.config(vim.deepcopy(opts.diagnostic))
    require("lsp_lines").setup()
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
    MAP("n", "[d", vim.diagnostic.goto_prev, diag_opts "move to the previous buffer diagnostic")
    MAP("n", "]d", vim.diagnostic.goto_next, diag_opts "move to the next buffer diagnostic")
    MAP(
        "n",
        "[w",
        function() vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.WARN } end,
        diag_opts "move to the previous buffer diagnostic warning"
    )
    MAP(
        "n",
        "]w",
        function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.WARN } end,
        diag_opts "move to the next buffer diagnostic warning"
    )
    MAP(
        "n",
        "[e",
        function() vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR } end,
        diag_opts "move to the previous buffer diagnostic error"
    )
    MAP(
        "n",
        "]e",
        function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR } end,
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
        function() vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0)) end,
        { silent = true, desc = "[LSP] toggle inlay hints for the current buffer" }
    )

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            -- local client = vim.lsp.get_client_by_id(args.data.client_id)

            -- Enable completion triggered by <c-x><c-o>
            vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

            local lb = vim.lsp.buf

            local function lsp_opts(desc) return { buffer = true, silent = true, desc = "[LSP] " .. desc } end
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            MAP("n", "<leader>cl", vim.lsp.codelens.run, lsp_opts "run one of the codelens actions")
            MAP("n", "gD", lb.declaration, lsp_opts "jumps to the declaration of the symbol under the cursor")
            MAP("n", "gd", lb.definition, lsp_opts "jumps to the definition of the symbol under the cursor")
            MAP("n", "K", function()
                local winid = nil
                if pcall(require, "ufo") then winid = require("ufo").peekFoldedLinesUnderCursor() end
                if not winid then vim.lsp.buf.hover() end
            end, lsp_opts "display hover information of the symbol under the cursor")
            MAP(
                "n",
                "<leader>gi",
                lb.implementation,
                lsp_opts "list all implementations for the symbol under the cursor"
            )
            MAP(
                { "i", "s" },
                "<C-h>",
                lb.signature_help,
                lsp_opts "display signature information about the symbol under the cursor"
            )
            MAP(
                "n",
                "<leader>wa",
                lb.add_workspace_folder,
                lsp_opts "add the folder at the path to the workspace folders"
            )
            MAP(
                "n",
                "<leader>wr",
                lb.remove_workspace_folder,
                lsp_opts "remove the folder at the path to the workspace folders"
            )
            MAP(
                "n",
                "<leader>lw",
                function() P(lb.list_workspace_folders()) end,
                lsp_opts "list workspace folders"
            )
            MAP(
                "n",
                "<leader>D",
                lb.type_definition,
                lsp_opts "jumps to the definition of the type of the symbol under the cursor"
            )
            MAP(
                "n",
                "<leader>rn",
                lb.rename,
                lsp_opts "renames all references of the symbol under the cursor"
            )
            MAP(
                "n",
                "<leader>ca",
                lb.code_action,
                lsp_opts "selects a code action available at the current cursor position"
            )
            MAP(
                "n",
                "gr",
                lb.references,
                lsp_opts "lists all the references to the symbol under the cursor in the quickfix window"
            )
            MAP("n", "<leader>lf", lsp_format, lsp_opts "formats the current buffer")
            MAP("n", "<leader>laf", toggle_autoformat, lsp_opts "toggle format current buffer on write")
        end,
    })

    local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities(),
        opts.additional_capabilities
    )

    for lsp, lsp_opts in pairs(opts.servers) do
        local new_lsp_opts = vim.tbl_deep_extend("force", {
            capabilities = capabilities,
        }, lsp_opts)
        require("lspconfig")[lsp].setup(new_lsp_opts)
    end

    -- don't start the cssls lsp server for the waybar config
    vim.api.nvim_create_autocmd("LspAttach", {
        pattern = "*/.config/waybar/style.css",
        callback = function(args) vim.lsp.stop_client(args.data.client_id) end,
        group = AUGROUP "lsp_disable_certain_files",
    })
    -- vim.cmd [[autocmd LspAttach,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]]
end

return M
