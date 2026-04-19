local M = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    branch = "main",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
    },
}

function M.config()
    local ensure_installed = {
        "ada",
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
        "systemverilog",
        "toml",
        "vhdl",
        "vim",
        "vimdoc",
        "yaml",
    }
    local filetypes = {}
    for _, lang in ipairs(ensure_installed) do
        for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
            table.insert(filetypes, ft)
        end
    end

    require("nvim-treesitter").install(ensure_installed):wait(300000)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        group = AUGROUP "treesitter_start",
        callback = function(args) vim.treesitter.start(args.buf) end,
    })

    require("nvim-treesitter-textobjects").setup {
        select = {
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
                ["@parameter.outer"] = "v", -- charwise
                ["@function.outer"] = "V", -- linewise
                ["@class.outer"] = "<c-v>", -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true of false
            include_surrounding_whitespace = false,
        },
        move = {
            -- whether to set jumps in the jumplist
            set_jumps = true,
        },
    }
    local function select_textobject(textobject)
        require("nvim-treesitter-textobjects.select").select_textobject(textobject, "textobjects")
    end
    local function swap_next(textobject) require("nvim-treesitter-textobjects.swap").swap_next(textobject) end
    local function swap_prev(textobject) require("nvim-treesitter-textobjects.swap").swap_previous(textobject) end
    local move = require "nvim-treesitter-textobjects.move"
    -- select
    vim.keymap.set({ "x", "o" }, "af", function() select_textobject "@function.outer" end)
    vim.keymap.set({ "x", "o" }, "if", function() select_textobject "@function.inner" end)
    vim.keymap.set({ "x", "o" }, "ac", function() select_textobject "@class.outer" end)
    vim.keymap.set({ "x", "o" }, "ic", function() select_textobject "@class.inner" end)
    -- swap
    vim.keymap.set("n", "<leader>a", function() swap_next "@parameter.inner" end)
    vim.keymap.set("n", "<leader>A", function() swap_prev "@parameter.inner" end)
    -- move
    vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "]]", function() move.goto_next_start("@class.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "][", function() move.goto_next_end("@class.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "[[", function() move.goto_previous_start("@class.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "[]", function() move.goto_previous_end("@class.outer", "textobjects") end)
    vim.keymap.set(
        { "n", "x", "o" },
        "]o",
        function() move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects") end
    )
    vim.keymap.set({ "n", "x", "o" }, "]s", function() move.goto_next_start("@local.scope", "locals") end)
    vim.keymap.set({ "n", "x", "o" }, "]z", function() move.goto_next_start("@fold", "folds") end)
    -- repeatable last move
    local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
end

return M
