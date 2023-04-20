return {
    { "nvim-treesitter/playground", cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" } },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufReadPost",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/nvim-treesitter-context",
        },
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "bash",
                    "bibtex",
                    "c",
                    "cmake",
                    "comment",
                    "cpp",
                    "css",
                    "diff",
                    "dockerfile",
                    "git_config",
                    "git_rebase",
                    "gitattributes",
                    "gitcommit",
                    "gitignore",
                    "glsl",
                    "html",
                    "javascript",
                    "json",
                    "json5",
                    "jsonc",
                    "latex",
                    "lua",
                    -- "luadoc",
                    "luap",
                    "make",
                    "markdown",
                    "markdown_inline",
                    "meson",
                    "python",
                    "query",
                    "rasi",
                    "regex",
                    "rust",
                    "toml",
                    "vim",
                    "vimdoc",
                    "yaml",
                },
                auto_install = false,
                highlight = {
                    enable = true,
                    -- disable = {},
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = false }, -- kinda annoying right now with unwanted autoindents
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "grn",
                        scope_incremental = "grc",
                        node_decremental = "grm",
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>a"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>A"] = "@parameter.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            -- ["]c"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            -- ["]C"] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            -- ["[c"] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            -- ["[C"] = "@class.outer",
                        },
                    },
                    lsp_interop = {
                        enable = true,
                        border = "none",
                        peek_definition_code = {
                            ["<leader>df"] = "@function.outer",
                            ["<leader>dF"] = "@class.outer",
                        },
                    },
                },
                playground = {
                    enable = true,
                    updatetime = 25,
                    persist_queries = true,
                    keybindings = {
                        toggle_query_editor = "o",
                        toggle_hl_groups = "i",
                        toggle_injected_languages = "t",

                        -- This shows stuff like literal strings, commas, etc.
                        toggle_anonymous_nodes = "a",
                        toggle_language_display = "I",
                        focus_language = "f",
                        unfocus_language = "F",
                        update = "R",
                        goto_node = "<cr>",
                        show_help = "?",
                    },
                },
            }

            require("treesitter-context").setup {
                enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
                max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
                min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                line_numbers = true,
                multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
                trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
                -- Separator between context and content. Should be a single character string, like '-'.
                -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                separator = nil,
                zindex = 20, -- The Z-index of the context window
            }

            -- vim.cmd [[
            -- set foldmethod=expr
            -- set foldexpr=nvim_treesitter#foldexpr()
            -- set nofoldenable
            -- ]]
        end,
    },
}
