return {
    "nvim-lua/plenary.nvim",
    { "nvim-tree/nvim-web-devicons", lazy = false },
    { "alvarosevilla95/luatab.nvim", event = "TabNew", config = true },
    { "tpope/vim-repeat", event = "VeryLazy" },
    { "tpope/vim-sleuth", event = "BufReadPre" },
    { "tpope/vim-surround", keys = { "ds", "cs", "ys", { "S", mode = "v" } } },
    {
        "karb94/neoscroll.nvim",
        keys = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        config = function()
            -- REF: https://github.com/karb94/neoscroll.nvim/issues/80
            require("neoscroll").setup {
                pre_hook = function()
                    ---@diagnostic disable-next-line: param-type-mismatch
                    vim.opt.eventignore:append {
                        "WinScrolled",
                        "CursorMoved",
                    }
                end,
                post_hook = function()
                    ---@diagnostic disable-next-line: param-type-mismatch
                    vim.opt.eventignore:remove {
                        "WinScrolled",
                        "CursorMoved",
                    }
                end,
            }
        end,
    },

    {
        "b0o/incline.nvim",
        lazy = false,
        config = function()
            require("incline").setup {
                hide = {
                    -- cursorline = true,
                    focused_win = true,
                },
                ignore = {
                    unlisted_buffers = false,
                    buftypes = {},
                    -- wintypes = {},
                },
                window = { margin = { vertical = 0 } },
                render = function(props)
                    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
                    -- local icon, color = require("nvim-web-devicons").get_icon_color(filename)
                    -- { icon, guifg = color }
                    local winnr = vim.fn.getwininfo(props.win)[1].winnr
                    return {
                        { winnr },
                        { " " },
                        { filename },
                    }
                end,
            }
        end,
    },

    -- {
    --     "kevinhwang91/nvim-ufo",
    --     dependencies = "kevinhwang91/promise-async",
    --     config = function()
    --         vim.o.foldcolumn = "1" -- '0' is not bad
    --         vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    --         vim.o.foldlevelstart = 99
    --         vim.o.foldenable = true
    --
    --         -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
    --         vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    --         vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    --
    --         require("ufo").setup {
    --             preview = {
    --                 mappings = {
    --                     scrollB = "<C-b>",
    --                     scrollF = "<C-f>",
    --                     scrollU = "<C-u>",
    --                     scrollD = "<C-d>",
    --                 },
    --             },
    --             provider_selector = function(_, filetype, buftype)
    --                 local function handleFallbackException(bufnr, err, providerName)
    --                     if type(err) == "string" and err:match "UfoFallbackException" then
    --                         return require("ufo").getFolds(bufnr, providerName)
    --                     else
    --                         return require("promise").reject(err)
    --                     end
    --                 end
    --
    --                 return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
    --                     or function(bufnr)
    --                         return require("ufo")
    --                             .getFolds(bufnr, "lsp")
    --                             :catch(
    --                                 function(err) return handleFallbackException(bufnr, err, "treesitter") end
    --                             )
    --                             :catch(function(err) return handleFallbackException(bufnr, err, "indent") end)
    --                     end
    --             end,
    --         }
    --     end,
    -- },

    -- -- TODO: plugins to try out
    -- "stevearc/aerial.nvim" -- use telescope lsp_document_symbols??
    -- "famiu/bufdelete.nvim"
    -- "ThePrimeagen/refactoring.nvim"
    -- "folke/noice.nvim"
}
