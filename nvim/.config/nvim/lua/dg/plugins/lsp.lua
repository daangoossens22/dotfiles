local M = {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
        "williamboman/mason.nvim", -- needs to be setup before the lsps are configured so that automatic_installation works
        "jose-elias-alvarez/null-ls.nvim",
        "p00f/clangd_extensions.nvim",
        "folke/neodev.nvim",
        -- "simrat39/rust-tools.nvim",
        { url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },
    },
}

function M.config()
    local lsp_augroup = vim.api.nvim_create_augroup("dg_lsp", { clear = true })

    local function toggle_autoformat() vim.b.autoformat = not vim.b.autoformat end

    local ignore = { "sumneko_lua", "jedi_language_server" }
    local function lsp_format()
        vim.lsp.buf.format {
            filter = function(format_client) return not vim.tbl_contains(ignore, format_client.name) end,
        }
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
            if vim.b.autoformat then lsp_format() end
        end,
        group = lsp_augroup,
    })

    local function lsp_opts(desc) return { silent = true, desc = "[LSP] " .. desc } end

    require("lsp_lines").setup()
    vim.diagnostic.config {
        -- update_in_insert = false, -- keep diagnostics while typing
        virtual_lines = false,
        virtual_text = true,
    }
    MAP("n", "<leader>e", function()
        local virtual_lines = vim.diagnostic.config().virtual_lines
        vim.diagnostic.config {
            -- update_in_insert = virtual_lines,
            virtual_lines = not virtual_lines,
            virtual_text = virtual_lines,
        }
    end, lsp_opts "toggle diagnostics on same or on new lines below")
    MAP("n", "<leader>ut", function()
        local underline = vim.diagnostic.config().underline
        vim.diagnostic.config {
            underline = not underline,
        }
    end, lsp_opts "toggle diagnostics underline")
    MAP("n", "[d", vim.diagnostic.goto_prev, lsp_opts "move to the previous buffer diagnostic")
    MAP("n", "]d", vim.diagnostic.goto_next, lsp_opts "move to the next buffer diagnostic")
    MAP("n", "<leader>q", function()
        if next(vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR })) == nil then
            vim.diagnostic.setqflist { severity = vim.diagnostic.severity.WARN }
        else
            vim.diagnostic.setqflist { severity = vim.diagnostic.severity.ERROR }
        end
    end, lsp_opts "add project diagnostics to the qflist (ERRORS, otherwise WARNINGS)")
    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        -- NOTE: track this for now https://github.com/neovim/neovim/issues/21576 (make sure you can override Todo comments highlight groups)
        client.server_capabilities.semanticTokensProvider = nil

        -- use null-ls formatting instead of the default formatting for the languageserver
        if client.name == "sumneko_lua" or client.name == "rust_analyzer" then toggle_autoformat() end

        local function buf_opts(desc)
            local opts = lsp_opts(desc)
            opts.buffer = 0
            return opts
        end

        local lb = vim.lsp.buf

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        MAP("n", "gD", lb.declaration, buf_opts "jumps to the declaration of the symbol under the cursor")
        MAP("n", "gd", lb.definition, buf_opts "jumps to the definition of the symbol under the cursor")
        MAP("n", "K", lb.hover, buf_opts "display hover information of the symbol under the cursor")
        MAP(
            "n",
            "<leader>gi",
            lb.implementation,
            buf_opts "list all implementations for the symbol under the cursor"
        )
        MAP(
            "i",
            "<C-h>",
            lb.signature_help,
            buf_opts "display signature information about the symbol under the cursor"
        )
        MAP(
            "n",
            "<leader>wa",
            lb.add_workspace_folder,
            buf_opts "add the folder at the path to the workspace folders"
        )
        MAP(
            "n",
            "<leader>wr",
            lb.remove_workspace_folder,
            buf_opts "remove the folder at the path to the workspace folders"
        )
        -- -- NOTE: conflicts with window mapping CTRL-W l -> <space>w l
        -- MAP("n", "<leader>wl", function()
        --     vim.inspect(lb.list_workspace_folders())
        -- end, buf_opts "list workspace folders")
        MAP(
            "n",
            "<leader>D",
            lb.type_definition,
            buf_opts "jumps to the definition of the type of the symbol under the cursor"
        )
        MAP("n", "<leader>rn", lb.rename, buf_opts "renames all references of the symbol under the cursor")
        MAP(
            "n",
            "<leader>ca",
            lb.code_action,
            buf_opts "selects a code action available at the current cursor position"
        )
        MAP(
            "n",
            "gr",
            lb.references,
            buf_opts "lists all the references to the symbol under the cursor in the quickfix window"
        )
        MAP("n", "<leader>lf", lsp_format, buf_opts "formats the current buffer")
        MAP("n", "<leader>laf", toggle_autoformat, buf_opts "toggle format current buffer on write")
    end

    local nvim_lsp = require "lspconfig"
    -- Add additional capabilities supported by nvim-cmp
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local null_ls = require "null-ls"
    null_ls.setup {
        sources = {
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.formatting.prettier,
            null_ls.builtins.formatting.yapf,
            null_ls.builtins.formatting.shellharden,
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
        on_attach = on_attach,
        capabilities = capabilities,
    }

    local servers = { "jedi_language_server", "bashls", "texlab", "tsserver", "cssls", "html", "jsonls" }
    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
            on_attach = on_attach,
            capabilities = capabilities,
        }
    end

    local rust_analyzer_setup = {
        cmd = { "rustup", "run", "stable", "rust-analyzer" },
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    }
    nvim_lsp.rust_analyzer.setup(rust_analyzer_setup)
    -- TODO: this also seems to require "dap", see how to seperate them
    -- TODO: once nvim natively supports inlay_hints -> don't need rust-tools anymore
    -- local extension_path = vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/extension/"
    -- local codelldb_path = extension_path .. "adapter/codelldb"
    -- local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
    -- require("rust-tools").setup {
    --     server = rust_analyzer_setup,
    --     tools = {
    --         inlay_hints = {
    --             auto = false,
    --         },
    --     },
    --     dap = {
    --         adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
    --     },
    -- }

    -- automatically sets up clangd language server
    require("clangd_extensions").setup {
        server = {
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
            on_attach = on_attach,
            capabilities = capabilities,
        },
        extensions = {
            autoSetHints = false,
        },
    }

    require("neodev").setup {
        setup_jsonls = false,
    }
    nvim_lsp.sumneko_lua.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            Lua = {
                telemetry = { enable = false },
                diagnostics = { globals = { "vim", "describe", "it", "before_each" } },
                completion = { callSnippet = "Replace" },
                workspace = { checkThirdParty = false },
                -- doesn't work with my highlight groups for TODO/NOTE comments
                semantic = { enable = false },
            },
        },
    }

    -- don't start the cssls lsp server for the waybar config
    vim.api.nvim_create_autocmd("LspAttach", {
        pattern = "*/.config/waybar/style.css",
        command = "LspStop cssls",
        group = lsp_augroup,
    })
end

return M
